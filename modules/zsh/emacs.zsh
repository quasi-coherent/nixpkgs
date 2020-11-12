E() { open -a ~/.nix-profile/Applications/Emacs.app/Contents/MacOS/Emacs "$@" & disown }
e() { command emacsclient -nq "$@" }

export E=E
export e=e
