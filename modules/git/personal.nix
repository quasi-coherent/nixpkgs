{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.git;
    userName = "Daniel Donohue";
    userEmail = "d.michael.donohue@gmail.com";

    extraConfig = {
      github.user = "quasi-coherent";
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
