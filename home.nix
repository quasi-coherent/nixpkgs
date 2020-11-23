{ config, pkgs, ... }:

let
  imports = [ ./modules ];
  sources = import ./nix;
  er-nix = import sources.er-nix;

in
{
  inherit imports;

  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "21.03";

  home.packages = with pkgs; [
    awscli
    awslogs
    bat
    cachix
    direnv
    feh
    fd
    fzf
    git
    gnupg
    htop
    jq
    kubectl
    kubectx
    kustomize
    metals
    niv
    nixfmt
    opam
    openjdk11
    nodejs
    ripgrep
    sbt
    tree
    vim
    wget
    yarn
    zsh
  ] ++ builtins.attrValues (er-nix.tools.haskell-language-servers);

  home.sessionVariables = {
    EDITOR = "vim";
    JAVA_HOME = pkgs.openjdk11;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.direnv.enableZshIntegration = true;

  programs.git = {
    enable = true;
    package = pkgs.git;
    userName = "Daniel Donohue";
    userEmail = "ddonohue@earnestresearch.com";

    extraConfig = {
      github.user = "quasi-coherent";
      pull.rebase = true;
      http.postBuffer = 1048576000;
      credential.helper = "osxkeychain";
    };

    signing = {
      key = "439E7CFD05576658";
      signByDefault = true;
    };
  };

  programs.home-manager.enable = true;
}
