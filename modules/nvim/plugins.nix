{pkgs, ...}:
{
  nvim-rust-tools = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-rust-tools";
    src = builtins.fetchGit {
      url = "https://github.com/simrat39/rust-tools.nvim";
      rev = "dba44e3dbd283e95f7ccd6ba258968fb5c191f3f";
    };
  };

  vim-ctrlspace = pkgs.vimUtils.buildVimPlugin {
    name = "vim-ctrlspace";
    src = builtins.fetchGit {
      url = "https://github.com/vim-ctrlspace/vim-ctrlspace";
      rev = "7ad53ecd905e22751bf3d31aef2db5f411976679";
    };
  };
}
