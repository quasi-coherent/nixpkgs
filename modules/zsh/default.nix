{ pkgs, config, ... }:

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
    defaultKeymap = "emacs";

    autocd = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=#cedcce,bg=#778177,underline";
      strategy = [
        "history"
        "completion"
      ];
    };

    history = {
      extended = true;
      share = true;
      ignoreSpace = true;
      saveNoDups = true;
      save = 100000;
      size = 100000;
    };

    historySubstringSearch.enable = true;
    historySubstringSearch.searchUpKey = "^P";
    historySubstringSearch.searchDownKey = "^N";

    oh-my-zsh = {
      enable = true;
      theme = "bureau";
      plugins = [
        "docker"
        "git"
        "kubectl"
        "kubectx"
        "ssh-agent"
      ];
    };

    enableCompletion = true;
    completionInit = ''
      if [ -f ${pkgs.zsh}/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        source ${pkgs.zsh}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      fi

      source <(${pkgs.kubectl} completion zsh)
    '';
    initContent =
      let
        zshConfigEarlyInit = pkgs.lib.mkOrder 500 ''
          if [ -f ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh ]; then
            source ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh
          fi

          if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
            source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          fi

          if [ -f ${config.home.homeDirectory}/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
            source ${config.home.homeDirectory}/.nix-profile/etc/profile.d/hm-session-vars.sh
          fi
        '';
        zshConfig = pkgs.lib.mkOrder 1000 ''
          ulimit -n 10240
          bindkey -e
        '';
      in pkgs.lib.mkMerge [ zshConfigEarlyInit zshConfig ];

    envExtra = ''
      DISABLE_AUTO_TITLE="true"
      if [ -f ${config.home.homeDirectory}/.env-extras ]; then
        source ${config.home.homeDirectory}/.env-extras
      fi
    '' + initExtraFunctions;
  };
}
