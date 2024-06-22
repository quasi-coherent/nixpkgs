{pkgs, ...}:
let
  themes = (import ./themes.nix) pkgs;
  plugins = (import ./plugins.nix) pkgs;
in
{
  programs.neovim = {
    enable = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      cmp-vsnip
      direnv-vim
      fzf-vim
      nvim-autopairs
      nvim-cmp
      nvim-lspconfig
      nvim-treesitter
      nvim-treesitter-refactor
      nvim-treesitter-textobjects
      plugins.vim-ctrlspace
      plugins.nvim-rust-tools
      themes.hemisu
      tcomment_vim
      vim-better-whitespace
      vim-fugitive
      vim-gitgutter
      vim-nix
      vim-sleuth
      vim-surround
      vim-terraform
      vim-vinegar
      vim-which-key
    ];

    extraConfig = ''
      ${builtins.readFile ./defaults.vim}

      lua << EOF
        ${builtins.readFile ./defaults.lua}
        ${builtins.readFile ./cmp.lua}
        ${builtins.readFile ./lsp.lua}
      EOF
    '';
  };
}
