{pkgs, ...}:

{
  hemisu = pkgs.vimUtils.buildVimPlugin {
    name = "hemisu";
    src = builtins.fetchGit {
      url = "https://github.com/noahfrederick/vim-hemisu";
      rev = "37ea6aace110e1e70acb32a3ec6dc9b7ae9009bf";
    };
  };
}
