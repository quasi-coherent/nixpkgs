{pkgs, ...}:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "emacs";
    terminal = "xterm-256color";
    historyLimit = 100000;
    sensibleOnTop = true;
    plugins = with pkgs.tmuxPlugins; [
      logging
      pain-control
      prefix-highlight
      tmux-fzf
      yank
    ];
  };
}
