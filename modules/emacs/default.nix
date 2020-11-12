{pkgs, ...}:

{
  imports = [ ./emacs.nix ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacsMacport;
    init.enable = true;
  };
}
