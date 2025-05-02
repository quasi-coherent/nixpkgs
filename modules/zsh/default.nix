{ config, ... }:

let
  functions = [
    ./functions/cargo-clean-all
    ./functions/colors
    ./functions/emacs
    ./functions/extract
    ./functions/json-pretty
  ];
  initExtraFunctions = builtins.foldl' (acc: f: acc + "\n" + builtins.readFile f) "" functions;
  shellAliases = {
    nuke-all = "nix-collect-garbage -d && docker system prune --volumes --force";
    fzf = "fzf --height 50% --border=none";
    gcm = "git checkout master 2>/dev/null || git checkout main";
    cdd = "cd $ZEROPW";
    ls = "eza";
    l = "eza --git-ignore";
    ll = "eza --all --header --long";
    llm = "eza --all --header --long --sort-modified";
    la = "eza -lbhHigUmuSa";
    lx = "eza -lbhHigUmuSa@";
    lt = "eza --tree";
    tree = "eza --tree";
    k = "kubectl";
  };

in
{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    extraOptions = [
      "--git"
      "--group"
      "--group-directories-first"
      "--time-style=long-iso"
      "--color-scale=all"
    ];
  };

  programs.zsh = {
    inherit shellAliases;

    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    defaultKeymap = "emacs";
    enableCompletion = true;
    history.extended = true;
    history.share = true;
    history.ignoreSpace = true;
    history.save = 100000;
    history.size = 100000;

    oh-my-zsh = {
      enable = true;
      theme = "bureau";
      plugins = [
        "git"
        "ssh-agent"
      ];
    };

    initExtra = ''
bindkey -e

DISABLE_AUTO_TITLE="true"

if [ -f ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh ]; then
  source ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh
fi

if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if [ -f ${config.home.homeDirectory}/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
  source ${config.home.homeDirectory}/.nix-profile/etc/profile.d/hm-session-vars.sh
fi

if [ -f /usr/local/share/zsh/site-functions/aws_zsh_completer.sh ]; then
  source /usr/local/share/zsh/site-functions/aws_zsh_completer.sh
fi

if [ -f ${config.home.homeDirectory}/.env-extras ]; then
  source ${config.home.homeDirectory}/.env-extras
fi

if command -v kubectl 1>/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

if command -v direnv 1>/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if [[ -n $VIRTUAL_ENV && -e $VIRTUAL_ENV/bin/activate ]]; then
  source "$VIRTUAL_ENV/bin/activate"
fi
    '' + initExtraFunctions;
  };
}
