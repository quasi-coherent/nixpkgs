{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.git;
    difftastic = {
      enable = true;
      background = "dark";
    };
    userName = "dddevis";
    userEmail = "daniel.donohue.devis@gmail.com";

    extraConfig = {
      github.user = "dddevis";
      pull.rebase = true;
      http.postBuffer = 1048576000;
    };

    signing = {
      signByDefault = true;
    };
  };
}
