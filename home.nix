{ config, pkgs, ... }:

let imports = [ ./modules ];

in
{
  inherit imports;

  home = {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    stateVersion = "21.03";
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = true;
  };

  home.packages = with pkgs; [
    awscli
    awslogs
    direnv
    fd
    fzf
    git
    gnupg
    htop
    jdk11
    jq
    kubectl
    kubectx
    kustomize
    niv
    nixfmt
    nodejs
    ripgrep
    tree
    wget
    zsh
  ];

  programs.home-manager.enable = true;

  programs.git = {
    package = pkgs.git;
    enable = true;
    userName = "Daniel Donohue";
    userEmail = "ddonohue@earnestresearch.com";
  };
}
