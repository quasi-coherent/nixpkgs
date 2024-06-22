{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.git;
    difftastic = {
      enable = true;
      background = "dark";
    };
    userName = "Daniel Donohue";
    userEmail = "daniel.donohue@beyondidentity.com";

    extraConfig = {
      github.user = "daniel.donohue";
      pull.rebase = true;
      http.postBuffer = 1048576000;
    };

    signing = {
      key = "77ECB1B9F076005E38C71B9048A4B7C74BFFE19D";
      signByDefault = true;
    };
  };
}
