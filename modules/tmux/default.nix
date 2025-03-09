{pkgs, ...}:

{
  programs.tmux = {
    enable = true;
    keyMode = "emacs";
    prefix = "C-]";
    newSession = true;
    clock24 = true;
    # This is broken and sets the shell to /bin/sh.
    sensibleOnTop = false;
    disableConfirmationPrompt  = true;
    escapeTime = 0;
    baseIndex = 1;
    historyLimit = 100000;

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = cpu;
        # home-manager puts `extraConfig` after plugins, which is wrong
        # because plugins that modify the status bar need to configured
        # before the `run-shell` calls.  So this has to happen in the first
        # plugin in the array.  This works, even though this is the
        # `extraConfig` of the very plugin the record defines, because the
        # opposite is true here: the `extraConfig` comes before `run-shell`.
        extraConfig = ''
          set -g status-right " MEM:#{ram_percentage} | CPU:#{cpu_percentage} | %y-%m-%d %H:%M %p"
        '';
      }
      logging
      pain-control
      prefix-highlight
      tmux-fzf
      tmux-thumbs
    ];

    extraConfig = ''
# The correct TERM within tmux is the following, even if
# the TERM of the terminal that tmux is in should be different.
set -g default-terminal tmux-256color

# For a terminal emulator that is able to report keystrokes
# outside of the standard, tmux also needs to have this
# enabled to forward them to applications in turn.
#
# This is the way to make emacs key sequences work the same
# within tmux within a terminal as they would just within
# a terminal alone.
set -s extended-keys on
set -as terminal-features 'xterm*:extkeys'

# Do not rename windows automatically
set -g allow-rename off

# Only resize the currently-viewed window not the whole session
set -g aggressive-resize on

# Forward formatted window titles to terminal
set -g set-titles on
set -g set-titles-string "#h: #W"

# Match numbers to keyboard
setw -g renumber-windows on
set -g pane-base-index 1

# No bells
set -g monitor-activity on
set -g activity-action none

# Copy/paste with hints, change triggers/highlight key.
set -g @thumbs-key F
bind-key \; thumbs-pick

# fzf in tmux with `C-] C-f`
TMUX_FZF_LAUNCH_KEY="C-f"

# Refresh status bar every 5 seconds
set -g status-interval 5
set -g status-justify left

# Status bar appearance (black and gray, less conspicuous)
set -g status-style "fg=black bg=colour235"
set -g message-style "fg=black bg=colour235"
set -g status-left-style "fg=black bg=colour235"
set -g status-right-style "fg=colour240 bg=black"

set -g mode-style "fg=black bg=colour235"
set -g window-status-current-style "fg=black bg=colour240"
set -g window-status-activity-style "fg=colour234 bg=colour236"

# A separate bar along the top that shows working directory and git branch.
set -g pane-border-status top
set -g pane-border-style "fg=colour240 bg=black"
set -g pane-border-format " #{pane_current_path} #(cd #{pane_current_path}; git rev-parse --abbrev-ref HEAD) "

set -g status-left-length 80
set -g status-right-length 80
  '';
  };
}
