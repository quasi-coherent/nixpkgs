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
    nodePackages.pyright
    python37
    python37Packages.virtualenv
  ];

  rsPkgs = with pkgs; [
    rust-analyzer
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
    awscli2
    awslogs
    aws-vault
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
    grpcurl
    htop
    httpie
    jq
    k9s
    kops
    kubectl
    kubectx
    kubernetes-helm
    niv
    nixfmt
    nodejs
    opam
    pgformatter
    ripgrep
    stern
    tree
    vim
    wget
    youtube-dl
  ] ++ goPkgs ++ pyPkgs ++ hsPkgs ++ rsPkgs ++ scalaPkgs;

  home.sessionVariables = {
    EDITOR = "vim";
    JAVA_HOME = pkgs.openjdk11;
  };

  home.sessionPath = [ "/usr/local/bin" "${homeDir}/.bin" ];

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  programs.direnv.enableZshIntegration = true;
}
