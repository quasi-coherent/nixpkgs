{ pkgs, inputs, ... }:

let
  lsps = with pkgs; [
    nodePackages.bash-language-server
    dockerfile-language-server-nodejs
    gopls
    haskell-language-server
    jdt-language-server
    nodePackages.vscode-json-languageserver
    marksman
    nil
    pyright
    rust-analyzer
    metals
    sqls
    terraform-ls
    nodePackages.typescript-language-server
    yaml-language-server
  ];
  homeDir = "/Users/danieldonohue";
in
rec {
  imports = [
    ../modules/emacs
    ../modules/nvim
    ../modules/zsh
    ../modules/git/bi.nix
  ];

  home.username = "danieldonohue";
  home.homeDirectory = homeDir;
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    awscli2
    awslogs
    bat
    bc
    cachix
    cargo-flamegraph
    cloc
    coreutils
    difftastic
    direnv
    dive
    doggo
    duf
    du-dust
    eksctl
    exiftool
    eza
    fd
    feh
    ffmpeg
    flamegraph
    fzf
    google-cloud-sdk
    git-filter-repo
    git-hub
    gnupg
    grpcurl
    htop
    httpie
    ispell
    jless
    jq
    k9s
    kops
    kubectl
    kubectx
    kubernetes-helm
    lf
    lnav
    lua
    moreutils
    nodejs
    openssh
    openssl
    parquet-tools
    pgformatter
    ripgrep
    sd
    steampipe
    stern
    sqlx-cli
    tree
    terraform
    terraform-ls
    tflint
    wget
    youtube-dl
    yq
  ] ++ inputs.darwin-frameworks ++ lsps;

  home.sessionVariables =
  let ZEROPW = "${homeDir}/go/src/gitlab.com/zeropw/zero";
  in {
    EDITOR = "vim";
    JAVA_HOME = "/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home/";
    GOPATH = "${homeDir}/go";
    ZEROPW = "${ZEROPW}";
    PROJECT_DIR = "${ZEROPW}";
  };

  home.sessionPath = [
    "/usr/local/bin"
    "${homeDir}/.bin"
    "${homeDir}/.cargo/bin"
    "${homeDir}/.local/bin"
    "${homeDir}/go/bin"
  ];

  programs.emacs.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.home-manager.enable = true;
}
