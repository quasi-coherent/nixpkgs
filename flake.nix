{
  description = "My home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, nur, ... }@inputs:
    let
      system = "x86_64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      nur-no-pkgs = import nur { nurpkgs = pkgs; };
      darwin-frameworks = with pkgs.darwin.apple_sdk.frameworks; [
        AppKit
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

        PATH=${with pkgs; nixpkgs.lib.makeBinPath [ nixfmt-rfc-style ]}

        nixfmt-rfc-style $check **/*.nix
      '';
    in {
      homeConfigurations = {
        "dmd@bi" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ nur.modules.homeManager.default ./users/bi.nix ];
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
