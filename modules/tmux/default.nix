{pkgs, ...}:

{
  programs.tmux = {
    enable = true;
    keyMode = "emacs";
    prefix = "C-]";
    newSession = true;
    clock24 = true;
    sensibleOnTop = false;
    disableConfirmationPrompt  = true;
    escapeTime = 0;
    terminal = "xterm-256color";
    baseIndex = 1;
    historyLimit = 100000;

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = cpu;
        # home-manager puts `extraConfig` after this plugin, which is wrong.
        extraConfig = ''
          set -g status-right " MEM:#{ram_percentage} | CPU:#{cpu_percentage} | %y-%m-%d %H:%M %p"
        '';
      }
      logging
      pain-control
      prefix-highlight
      tmux-fzf
      tmux-thumbs
      yank
    ];

    extraConfig = ''
# More intuitive than `C-] %` and `C-] "` for splitting panes
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Fullscreen mode
bind t set-option status

# fcsonline/tmux-thumbs
set -g @thumbs-key F
# sainnhe/tmux-fzf
TMUX_FZF_LAUNCH_KEY="C-f"

# Do not rename windows automatically
set-option -g allow-rename off

# Only resize the currently-viewed window not the whole session
set -g aggressive-resize on

# Forward window titles to terminal
set -g set-titles on
set -g set-titles-string "#h: #W"

# Match numbers to keyboard
set -g pane-base-index 1
setw -g renumber-windows on

# No "bell" sounds
set -g monitor-activity on
set -g activity-action none

# Status bar
set -g status-interval 5
set -g status-justify left
set -g status-style "fg=black bg=colour235"
set -g message-style "fg=black bg=colour235"
set -g status-left-style "fg=black bg=colour235"
set -g status-right-style "fg=colour240 bg=black"

set -g mode-style "fg=black bg=colour235"
set -g window-status-current-style "fg=black bg=colour240"
set -g window-status-activity-style "fg=colour234 bg=colour236"

set -g status-right-length 80

# Ensure /bin/sh is not used
set -gu default-command
set -g default-shell "$SHELL"
  '';
  };
}
