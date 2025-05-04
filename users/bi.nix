{ pkgs, inputs, ... }:

let
  lsps = with pkgs; [
    nodePackages.bash-language-server
    dhall-lsp-server
    dockerfile-language-server-nodejs
    gopls
    haskell-language-server
    helm-ls
    jdt-language-server # java
    nodePackages.vscode-json-languageserver
    marksman # md
    nil # nix
    pyright
    rust-analyzer
    metals # scala
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
    alacritty
    ansifilter # remove terminal escape sequences from input
    awscli2
    awslogs # cloudwatch log streams
    aws-vault
    bat # better `cat`
    bc # calculator
    cachix
    cloc
    cloudsmith-cli
    cmake
    coreutils
    coreutils-prefixed
    dhall
    dhall-yaml
    dhall-json
    difftastic # `difft`: syntax-aware file diff
    direnv
    dive # introspect docker image layers
    doggo # better `dig`
    duf # better `df`
    du-dust # `dust`: better `du`
    dune_3 # `dune`: ocaml build system
    eksctl
    emacs-lsp-booster
    exiftool # exif data for image files
    eza # better `ls`
    fd # better `find`
    fzf # command-line fuzzy finder
    google-cloud-sdk
    git-filter-repo # rewrite git history
    git-hub
    gnupg
    grpcurl # curl for gRPC
    htop
    httpie # `http`: better `curl`
    ispell # spellcheck
    jless # `less` for json
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
    lf # terminal file manager
    lua
    measureme # rustc profiling
    moreutils # expanded core unix utilities
    ocamlformat_0_26_1
    opam # ocaml package manager
    openssh
    openssl
    otel-desktop-viewer # otel span collector in-browser
    parquet-tools # introspect .parquet
    pgformatter # not-very-good sqlformat for pgsql
    rainfrog # terminal db client
    ra-multiplex # multiplexer for rust-analyzer
    reattach-to-user-namespace # tmux/system clipboard share
    ripgrep
    ocamlPackages.rtop # ocaml repl
    scc
    sd # better `sed`
    steampipe # query apis with sql
    stern # k8s log tailing
    tree-sitter
    terraform
    terraform-ls
    tflint
    util-linux # Assorted utilities
    ocamlPackages.utop
    wget
    xmlsec
    yt-dlp
    yq
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
