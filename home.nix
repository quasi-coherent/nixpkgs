let
  imports = [ ./modules ];
  sources = import ./nix;
  pkgs = import sources.nixpkgs {};
  er-nix = import sources.er-nix;

  homeDir = builtins.getEnv "HOME";

  # Versions of hls not available in standard nixpkgs
  hsPkgs = builtins.attrValues (er-nix.tools.haskell-language-servers);

  pyPkgs = with pkgs; [
    python37
    python37Packages.python-language-server
    python37Packages.virtualenv
  ];

  scalaPkgs = with pkgs; [
    openjdk11
    sbt
    scala_2_12
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
  ] ++ hsPkgs ++ pyPkgs ++ scalaPkgs;

  home.sessionVariables = {
    EDITOR = "vim";
    JAVA_HOME = pkgs.openjdk11;
  };

  home.sessionPath = [ "/usr/local/bin" "${homeDir}/.bin" ];

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
