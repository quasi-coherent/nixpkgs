let
  imports = [ ../modules ];
  sources = import ../nix;
  pkgs = import sources.nixpkgs {};

  homeDir = builtins.getEnv "HOME";

  goPkgs = with pkgs; [
    gopls
  ];

  hsPkgs = with pkgs; [
    haskellPackages.haskell-language-server
  ];

  pyPkgs = with pkgs; [
    python37
    python37Packages.python-language-server
    python37Packages.virtualenv
  ];

  scalaPkgs = with pkgs; [
    metals
  ];

in
{
  inherit imports;

  home.username = builtins.getEnv "USER";
  home.homeDirectory = homeDir;
  home.stateVersion = "21.03";

  home.packages = with pkgs; [
    awscli
    awslogs
    bat
    cachix
    direnv
    exiftool
    exa
    fd
    feh
    ffmpeg
    fzf
    gnupg
    htop
    httpie
    jq
    kubectl
    kubectx
    kustomize
    niv
    nixfmt
    nodejs
    opam
    pgformatter
    ripgrep
    tree
    vim
    wget
  ] ++ goPkgs ++ pyPkgs ++ hsPkgs ++ scalaPkgs;

  home.sessionVariables = {
    EDITOR = "vim";
    JAVA_HOME = pkgs.openjdk11;
  };

  home.sessionPath = [ "/usr/local/bin" "${homeDir}/.bin" ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.home-manager.enable = true;

  programs.direnv.enableZshIntegration = true;
}
