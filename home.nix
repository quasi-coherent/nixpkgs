{ config, pkgs, ... }:

let
  imports = [ ./modules ];
  sources = import ./nix;
  er-nix = import sources.er-nix;

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
  ] ++ builtins.attrValues (er-nix.tools.haskell-language-servers);

  programs.home-manager.enable = true;

  programs.git = {
    package = pkgs.git;
    enable = true;
    userName = "Daniel Donohue";
    userEmail = "ddonohue@earnestresearch.com";
  };
}
