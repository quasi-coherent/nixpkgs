{pkgs, ...}:
let
  themes = (import ./themes.nix) pkgs;
in
{
  programs.vim = {
    enable = true;

    plugins = [
      themes.hemisu
    ];

    extraConfig = ''
      ${builtins.readFile ./defaults.vim}
    '';
  };
}
