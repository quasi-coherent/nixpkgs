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
    };

    signing = {
      key = "C8E38F6173FB74D2C415C98D1FE02CFE20E556EF";
      signByDefault = true;
    };
  };
}
