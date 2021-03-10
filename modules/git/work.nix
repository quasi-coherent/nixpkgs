{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.git;
    userName = "Daniel Donohue";
    userEmail = "daniel.donohue@beyondidentity.com";

    extraConfig = {
      github.user = "daniel.donohue";
      pull.rebase = true;
      http.postBuffer = 1048576000;
      # credential.helper = "osxkeychain";
    };

    # signing = {
    #   key = "439E7CFD05576658";
    #   signByDefault = true;
    # };
  };
}
