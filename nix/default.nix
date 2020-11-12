let
  sources = import ./sources.nix;
in
rec {
  inherit (sources) er-nix home-manager nixpkgs NUR;
}
