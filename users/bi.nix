{ pkgs, inputs, ... }:

let
  lsps = with pkgs; [
    nodePackages.bash-language-server
    dhall-lsp-server
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
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    ansifilter
    awscli2
    awslogs
    aws-vault
    bat
    bc
    cachix
    cloc
    cmake
    coreutils
    coreutils-prefixed
    dhall
    dhall-yaml
    dhall-json
    difftastic
    direnv
    dive
    doggo
    duf
    du-dust
    dune_3
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
    kubectl-gadget
    kubectl-ktop
    kubectl-klock
    kubectl-images
    kubectl-neat
    kubectl-tree
    kubectl-validate
    kubectx
    kubernetes-helm
    lf
    lua
    measureme
    moreutils
    nodejs_20
    ocamlformat_0_26_1
    opam
    openssh
    openssl
    otel-desktop-viewer
    parquet-tools
    pgformatter
    rainfrog
    ripgrep
    ocamlPackages.rtop
    sd
    steampipe
    stern
    tree
    tree-sitter
    terraform
    terraform-ls
    tflint
    ocamlPackages.utop
    nodePackages.typescript
    wget
    xmlsec
    yt-dlp
    yq
    zoxide
  ] ++ inputs.darwin-frameworks ++ lsps;

  home.sessionVariables =
  let ZEROPW = "${homeDir}/go/src/gitlab.com/zeropw/zero";
  in {
    EDITOR = "emacs -Q -nw";
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
