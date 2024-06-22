{
  description = "My home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nur,
    ...
  } @ inputs: let
      system = "x86_64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            nixpkgs-unstable = import nixpkgs-unstable {
              inherit system;
              overlays = [];
            };
          })
        ];
      };
      nur-no-pkgs = import nur { nurpkgs = pkgs; };
      darwin-frameworks = with pkgs.darwin.apple_sdk.frameworks; [
        AppKit
        AppKitScripting
        CoreFoundation
        CoreServices
        Security
        SystemConfiguration
      ];
      format-all = pkgs.writeShellScriptBin "format-all" ''
        set -euo pipefail

        if [[ $# -gt 0 && $1 = "-c" ]]; then
          check="--check"
        else
          check=""
        fi

        PATH =${with pkgs; nixpkgs.lib.makeBinPath [ nixfmt ]}

        nixfmt $check **/*.nix
      '';
    in {
      homeConfigurations = {
        "dmd@bi" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            nur.hmModules.nur
            ./users/bi.nix
          ];
          extraSpecialArgs = {
            inherit nur-no-pkgs;
            inputs = {
              inherit inputs;
              darwin-frameworks = darwin-frameworks;
            };
          };
        };
      };
      devShells.x86_64-darwin.default = pkgs.mkShell {
        name = "dev-shell";
        nativeBuildInputs = [ format-all ];
      };
    };
}
