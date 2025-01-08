{ pkgs, inputs, ... }:

let
  lsps = with pkgs; [
    nodePackages.bash-language-server
    dockerfile-language-server-nodejs
    gopls
    haskell-language-server
    helm-ls
    jdt-language-server
    nodePackages.vscode-json-languageserver
    marksman
    nil
    pyright
    nixpkgs-unstable.rust-analyzer
    metals
    sqls
    terraform-ls
    nodePackages.typescript-language-server
    yaml-language-server
  ];
  homeDir = "/Users/danieldonohue";
in
{
  imports = [
    ../modules
    ../modules/git/bi.nix
  ];

  home.username = "danieldonohue";
  home.homeDirectory = homeDir;
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    awscli2
    awslogs
    aws-vault
    bat
    bc
    cachix
    cloc
    coreutils
    difftastic
    direnv
    dive
    doggo
    duf
    du-dust
    eksctl
    emacs-lsp-booster
    exiftool
    eza
    fd
    feh
    ffmpeg
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
    measureme
    moreutils
    nodejs_20
    openssh
    openssl
    parquet-tools
    pgformatter
    ripgrep
    sd
    steampipe
    stern
    tree
    tree-sitter
    terraform
    terraform-ls
    tflint
    nodePackages.typescript
    wget
    xmlsec
    yt-dlp
    yq
  ] ++ inputs.darwin-frameworks ++ lsps;

  home.sessionVariables =
  let ZEROPW = "${homeDir}/go/src/gitlab.com/zeropw/zero";
  in {
    EDITOR = "vim";
    JAVA_HOME = "/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home/";
    CARGO_HOME = "${homeDir}/.cargo";
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
