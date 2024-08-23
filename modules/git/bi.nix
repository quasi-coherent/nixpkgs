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
      credential.helper = "store";
    };

    signing = {
      key = "77ECB1B9F076005E38C71B9048A4B7C74BFFE19D";
      signByDefault = true;
    };

    delta = {
      enable = true;
      options = {
        features = "decorations";
        interactive = {
          keep-plus-minus-markers = false;
        };
        decorations = {
          commit-decoration-style = "blue ol";
          commit-style = "raw";
          file-style = "omit";
          hunk-header-decoration-style = "blue box";
          hunk-header-file-style = "red";
          hunk-header-line-number-style = "#067a00";
          hunk-header-style = "file line-number syntax";
        };
      };
    };
  };
}
