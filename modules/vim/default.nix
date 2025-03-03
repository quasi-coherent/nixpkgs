{pkgs, ...}:
let
  themes = (import ./themes.nix) pkgs;
in
{
  programs.vim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      fzf-vim
      themes.hemisu
      vim-better-whitespace
      vim-fugitive
      vim-gitgutter
      vim-sleuth
      vim-surround
      vim-vinegar
      vim-which-key
    ];

    extraConfig = ''
      ${builtins.readFile ./defaults.vim}
    '';
  };
}
