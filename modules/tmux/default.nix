{pkgs, ...}:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    sensibleOnTop = true;
    plugins = with pkgs.tmuxPlugins; [
      logging
      pain-control
      yank
    ];
  };
}
