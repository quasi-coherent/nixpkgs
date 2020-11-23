{ config, lib, pkgs, ... }:

let
  extras = [
    ./zsh/emacs.zsh
    ./zsh/extract.zsh
  ];
  extraInitExtra = builtins.foldl' (soFar: new: soFar + "\n" + builtins.readFile new) "" extras;
  shellAliases = {
    brew = "/usr/local/bin/brew";
    garbage = "nix-collect-garbage -d && docker image prune --force";
  };
in
{
  programs.zsh = {
    inherit shellAliases;

    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    history.extended = true;

    initExtra = ''
    export TERM="xterm-256color"

    bindkey -e

    if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
      . ~/.nix-profile/etc/profile.d/nix.sh
    fi

    if [ -e ~/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
      . ~/.nix-profile/etc/profile.d/hm-session-vars.sh
    fi

    if command -v kubectl 1>/dev/null 2>&1; then
      source <(kubectl completion zsh)
    fi

    if [ -f "/usr/local/share/zsh/site-functions/aws_zsh_completer.sh" ]; then
      source /usr/local/share/zsh/site-functions/aws_zsh_completer.sh
    fi

    if command -v direnv 1>/dev/null 2>&1; then
       eval "$(direnv hook zsh)"
    fi

    if command -v pyenv 1>/dev/null 2>&1; then
      eval "$(pyenv init -)"
    fi
    '' + extraInitExtra;

    oh-my-zsh = {
      enable = true;
      theme = "bureau";
      plugins = [
        "git"
        "common-aliases"
        "ssh-agent"
      ];
    };
  };
}
