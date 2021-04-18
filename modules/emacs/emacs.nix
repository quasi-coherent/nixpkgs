{ pkgs, ... }:

let
  nurNoPkgs = import (import ../../nix).NUR {};
in
{
  imports = [ nurNoPkgs.repos.rycee.hmModules.emacs-init ];

  programs.emacs.init = {
    enable = true;
    recommendedGcSettings = true;

    earlyInit = ''
      ;; Disable GUI distractions
      (push '(menu-bar-lines . 0) default-frame-alist)
      (push '(tool-bar-lines . nil) default-frame-alist)
      (push '(vertical-scroll-bars . nil) default-frame-alist)
    '';

    prelude = ''
      (setq inhibit-startup-screen t
            inhibit-startup-echo-area-message (user-login-name))

      (setq make-backup-files nil)
      (setq create-lockfiles nil)

      (custom-set-variables '(package-archives
                              '(("melpa"     . "https://melpa.org/packages/")
                                ("elpa"      . "https://elpa.gnu.org/packages/")
                                ("org"       . "http://orgmode.org/elpa/"))))

      (package-initialize)

      (setq user-full-name "Daniel Donohue"
	    user-mail-address "d.michael.donohue@gmail.com")

      (setq ring-bell-function 'ignore)       ; The sound that plays when you press C-g is annoying
      (custom-set-variables '(use-package-always-ensure t))
      (custom-set-variables '(use-package-always-defer t))
      (custom-set-variables '(use-package-verbose nil))
      (global-set-key (kbd "C-x C-b") 'ibuffer) ; use ibuffer instead of buffer-menu
      (global-set-key (kbd "C-<return>") 'toggle-frame-fullscreen) ; easily enter fullscreen mode
      (setq history-length 100)
      (put 'minibuffer-history 'history-length 50)
      (put 'kill-ring 'history-length 25)

      (setq tab-always-indent 'complete)      ; smart tab behavior
      (setq-default indent-tabs-mode nil)     ; death to tabs!
      (column-number-mode t)                  ; show the column number in the mode line
      (global-auto-revert-mode t)             ; revert buffers when underlying files change
      (delete-selection-mode t)               ; delete region with one keypress

      ;; Dealing with unnecessary whitespace
      (custom-set-variables '(show-trailing-whitespace t))
      (add-hook 'before-save-hook 'delete-trailing-whitespace)

      ;; Store backup and autosave files in /var/folders/
      (setq backup-directory-alist
	    `((".*" . ,temporary-file-directory)))
      (setq auto-save-file-name-transforms
	    `((".*" ,temporary-file-directory t)))

      ;; Show gutter line numbers in every buffer
      (global-display-line-numbers-mode)

      ;; Kill lines backward
      (global-set-key (kbd "C-<backspace>") (lambda ()
					      (interactive)
					      (kill-line 0)
					      (indent-according-to-mode)))
    '';

    usePackage = {
      ace-window = {
        enable = true;
        bind = {
          "C-x o" = "ace-window";
        };
        config = "(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))";
      };

      autorevert = {
        enable = true;
        diminish = [ "auto-revert-mode" ];
        command = [ "auto-revert-mode" ];
      };

      avy = {
        enable = true;
        bind = {
          "M-j" = "avy-goto-word-or-subword-1";
        };
        config = ''
          (setq avy-all-windows t)
        '';
      };

      blacken = {
        enable = true;
        config = ''
          (setq blacken-only-if-project-is-blackened t)
        '';
        hook = [
          "(python-mode . blacken-mode)"
        ];
      };

      browse-at-remote = {
        command = [ "browse-at-remote" ];
      };

      company = {
        enable = true;
        diminish = [ "company-mode" ];
        init = "(global-company-mode t)";
      };

      company-box = {
        enable = true;
        diminish = [ "company-box" ];
        after = [ "company" ];
        hook = [
          "(company-mode . company-box-mode)"
        ];
      };

      counsel = {
        enable = true;
        bind = {
          "C-x C-d" = "counsel-dired-jump";
          "C-x C-f" = "counsel-find-file";
          "C-x M-f" = "counsel-fzf";
          "C-x C-r" = "counsel-recentf";
          "C-x C-y" = "counsel-yank-pop";
          "M-x" = "counsel-M-x";
        };
        diminish = [ "counsel-mode" ];
        config =
          let
            fd = "${pkgs.fd}/bin/fd";
            fzf = "${pkgs.fzf}/bin/fzf";
          in ''
            (setq counsel-fzf-cmd "${fd} --type f | ${fzf} -f \"%s\"")
          '';
      };

      direnv = {
        enable = true;
        command = [ "direnv-mode" "direnv-update-environment" ];
      };

      dhall-mode = {
        enable = true;
        config = ''
          (setq dhall-format-at-save nil
                dhall-use-header-line nil)
        '';
      };

      dockerfile-mode.enable = true;

      doom-modeline = {
        enable = true;
        hook = [ "(after-init . doom-modeline-mode)" ];
        config = ''
          (setq doom-modeline-buffer-file-name-style 'relative-from-project
                doom-modeline-lsp t
                doom-modeline-icon nil
                doom-modeline-major-mode-icon nil)
        '';
      };

      ediff = {
        enable = true;
        defer = true;
        config = ''
          (setq ediff-window-setup-function 'ediff-setup-windows-plain)
        '';
      };

      eldoc = {
        enable = true;
        diminish = [ "eldoc-mode" ];
        command = ["eldoc-mode" ];
      };

      electric = {
        enable = true;
        command = [ "electric-indent-local-mode" ];
        hook = [
          "(elecric-indent-mode)"
          "(nix-mode . (lambda () (electric-indent-local-mode -1)))"
        ];
      };

      etags = {
        enable = true;
        defer = true;
        config = "(setq tags-revert-without-query t)";
      };

      flx.enable = true;

      flycheck = {
        enable = true;
        diminish = [ "flycheck-mode" ];
        command = [ "global-flycheck-mode" ];
        defer = 1;
        bind = {
          "M-n" = "flycheck-next-error";
          "M-p" = "flycheck-previous-error";
        };
        config = ''
          ;; Only check buffer when mode is enabled or buffer is saved.
          (setq flycheck-check-syntax-automatically '(mode-enabled save))

          ;; Enable flycheck in all eligible buffers.
          (global-flycheck-mode)
        '';
      };

      git-gutter-fringe = {
        enable = true;
        init = "(global-git-gutter-mode t)";
      };

      go-mode = {
        enable = true;
        mode = [
          ''("\\.go\\'" . go-mode)''
        ];
        hook = [
          "(go-mode . lsp-deferred)"
        ];
      };

      js = {
        enable = true;
        mode = [
          ''("\\.js\\'" . js-mode)''
          ''("\\.json\\'" . js-mode)''
        ];
        config = ''
          (setq js-indent-level 2)
        '';
      };

      haskell-mode = {
        enable = true;
        mode = [
          ''("\\.hs\\'" . haskell-mode)''
          ''("\\.hsc\\'" . haskell-mode)''
          ''("\\.c2hs\\'" . haskell-mode)''
          ''("\\.cpphs\\'" . haskell-mode)''
          ''("\\.lhs\\'" . haskell-literate-mode)''
        ];
        hook = [
          "(haskell-mode . interactive-haskell-mode)"
          "(haskell-mode . subword-mode)"
        ];
        bindLocal = {
          haskell-mode-map = {
            "C-c h i" = "haskell-navigate-imports";
            "C-c r o" = "haskell-mode-format-imports";
            "C-<right>" = "haskell-move-nested-right";
            "C-<left>" = "haskell-move-nested-left";
          };
        };
        config = ''
          (setq tab-width 2)

          (setq haskell-process-log t
                haskell-notify-p t)

          (setq haskell-stylish-on-save t)

          (setq haskell-process-args-cabal-repl
                '("--ghc-options=+RTS -M500m -RTS -ferror-spans -fshow-loaded-modules"))
        '';
      };

      haskell-cabal = {
        enable = true;
        mode = [ ''("\\.cabal\\'" . haskell-cabal-mode)'' ];
        bindLocal = {
          haskell-cabal-mode-map = {
            "C-c C-c" = "haskell-process-cabal-build";
            "C-c c" = "haskell-process-cabal";
            "C-c C-b" = "haskell-interactive-bring";
          };
        };
      };

      hemisu-theme = {
        enable = true;
        init = "(load-theme 'hemisu-dark t)";
      };

      ivy = {
        enable = true;
        demand = true;
        diminish = [ "ivy-mode" ];
        command = [ "ivy-mode" ];
        config = ''
          (setq ivy-use-virtual-buffers t
                ivy-count-format "%d/%d "
                ivy-virtual-abbreviate 'full
                ivy-re-builders-alist '((swiper-isearch . ivy--regex-plus)
                                        (t              . ivy--regex-fuzzy)))

          (ivy-mode 1)
        '';
      };

      ivy-hydra = {
        enable = true;
        defer = true;
        after = [ "ivy" "hydra" ];
      };

      ivy-xref = {
        enable = true;
        after = [ "ivy" "xref" ];
        command = [ "ivy-xref-show-xrefs" ];
        config = ''
          (setq xref-show-xrefs-function #'ivy-xref-show-xrefs)
        '';
      };

      lsp-completion = {
        enable = true;
        after = [ "lsp-mode" ];
        config = ''
          (setq lsp-completion-enable-additional-text-edit nil)
        '';
      };

      lsp-diagnostics = {
        enable = true;
        after = [ "lsp-mode" ];
      };

      lsp-go = {
        enable = true;
        defer = true;
        hook = [''
          (go-mode . (lambda ()
                      (direnv-update-environment)
                      (lsp)))
        ''];
      };

      lsp-haskell = {
        enable = true;
        defer = true;
        config = ''
          (setq lsp-haskell-process-path-hie "haskell-language-server-wrapper")
        '';
        hook = [''
          (haskell-mode . (lambda ()
                           (direnv-update-environment)
                           (lsp)))
        ''];
      };

      lsp-ivy = {
        enable = true;
        after = [ "lsp-mode" ];
        command = [ "lsp-ivy-workspace-symbol" ];
      };

      lsp-mode = {
        enable = true;
        command = [ "lsp" ];
        after = [ "company" "flycheck" ];
        hook = [ "(lsp-mode . lsp-enable-which-key-integration)" ];
        bindLocal = {
          lsp-mode-map = {
            "C-c r r" = "lsp-rename";
            "C-c r f" = "lsp-format-buffer";
            "C-c r g" = "lsp-format-region";
            "C-c r a" = "lsp-execute-code-action";
            "C-c f r" = "lsp-find-references";
          };
        };
        init = ''
          (setq lsp-keymap-prefix "C-c l")
        '';
        config = ''
          (setq lsp-diagnostics-provider :flycheck
                lsp-eldoc-render-all nil
                lsp-modeline-code-actions-enable nil
                lsp-modeline-diagnostics-enable nil)
          (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
        '';
      };

      lsp-modeline = {
        enable = true;
        after = [ "lsp-mode" ];
      };

      lsp-pyright = {
        enable = true;
        defer = true;
        hook = [''
          (python-mode . (lambda ()
                           (direnv-update-environment)
                           (require 'lsp-pyright)
                           (lsp)))
        ''];
      };

      lsp-ui = {
        enable = true;
        command = [ "lsp-ui-mode" ];
        bindLocal = {
          lsp-mode-map = {
            "C-c r d" = "lsp-ui-doc-glance";
            "C-c f s" = "lsp-ui-find-workspace-symbol";
          };
        };
        config = ''
          (setq lsp-ui-sideline-enable t
                lsp-ui-sideline-show-symbol nil
                lsp-ui-sideline-show-hover nil
                lsp-ui-sideline-show-code-actions nil
                lsp-ui-sideline-update-mode 'point)
          (setq lsp-ui-doc-enable nil
                lsp-ui-doc-position 'at-point
                lsp-ui-doc-max-width 120
                lsp-ui-doc-max-height 15)
        '';
      };

      lsp-ui-flycheck = {
        enable = true;
        after = [ "flycheck" "lsp-ui" ];
      };

      magit = {
        enable = true;
        diminish = ["auto-revert-mode"];
        bind = {
          "C-c C-g" = "magit-status";
        };
      };

      multiple-cursors = {
        enable = true;
        bind = {
          "C-S-c C-S-c" = "mc/edit-lines";
          "C-c m" = "mc/mark-all-like-this";
          "C->" = "mc/mark-next-like-this";
          "C-<" = "mc/mark-previous-like-this";
        };
      };

      nix-mode = {
        enable = true;
        hook = [ "(nix-mode . subword-mode)" ];
      };

      org = {
        enable = true;
        bind = {
          "C-c o c" = "org-capture";
          "C-c o a" = "org-agenda";
          "C-c o l" = "org-store-link";
          "C-c o b" = "org-switchb";
        };
        hook = [
          ''
            (org-mode
             . (lambda ()
                 (add-hook 'completion-at-point-functions
                           'pcomplete-completions-at-point nil t)))
          ''
        ];
        config = ''
          ;; Some general stuff.
          (setq org-reverse-note-order t
                org-use-fast-todo-selection t
                org-adapt-indentation nil
                org-hide-leading-stars t
                org-hide-emphasis-markers t)

          ;; Add some todo keywords.
          (setq org-todo-keywords
                '((sequence "TODO(t)"
                            "STARTED(s!)"
                            "WAITING(w@/!)"
                            "DELEGATED(@!)"
                            "|"
                            "DONE(d!)"
                            "CANCELED(c@!)")))

          ;; Unfortunately org-mode tends to take over keybindings that
          ;; start with C-c.
          (unbind-key "C-c SPC" org-mode-map)
          (unbind-key "C-c w" org-mode-map)
        '';
      };

      org-agenda = {
        enable = true;
        after = [ "org" ];
        defer = true;
        config = ''
          ;; Set up agenda view.
          (setq org-agenda-span 5
                org-deadline-warning-days 14
                org-agenda-show-all-dates t
                org-agenda-skip-deadline-if-done t
                org-agenda-skip-scheduled-if-done t
                org-agenda-start-on-weekday nil)
        '';
      };

      org-capture = {
        enable = true;
        after = [ "org" ];
      };

      org-clock = {
        enable = true;
        after = [ "org" ];
        config = ''
          (setq org-clock-rounding-minutes 5
                org-clock-out-remove-zero-time-clocks t)
        '';
      };

      org-superstar = {
        enable = true;
        hook = [ "(org-mode . org-superstar-mode)" ];
      };

      projectile = {
         enable = true;
         diminish = [ "projectile-mode" ];
         command = [ "projectile-mode" "projectile-project-root" ];
         bindKeyMap = {
           "C-c p" = "projectile-command-map";
         };
         config = ''
           (setq projectile-enable-caching t
                 projectile-completion-system 'ivy)
           (projectile-mode 1)
         '';
       };

      protobuf-mode.enable = true;

      python = {
        enable = true;
        mode = [
          ''("\\.py\\'" . python-mode)''
        ];
        config = ''
          (setq tab-width 4)
          (setq py-indent-offset 4)
        '';
      };

      rustic.enable = true;

      smartparens = {
        enable = true;
        diminish = [ "smartparens-mode" ];
        init = ''
          (require 'smartparens-config)
          (show-smartparens-global-mode)
          (smartparens-global-mode t)
        '';
      };

      sqlformat = {
        enable = true;
        config = ''
          (setq sqlformat-command 'pgformatter)
          (setq sqlformat-args '("-s2" "-g"))
        '';
        hook = [ "(sql-mode . sqlformat-on-save-mode)" ];
      };

      swiper = {
        enable = true;
        command = [ "swiper" "swiper-all" "swiper-isearch" ];
        bind = {
          "C-s" = "swiper-isearch";
        };
      };

      terraform-mode.enable = true;

      typescript-mode.enable = true;

      which-key = {
        enable = true;
        command = [ "which-key-mode" "which-key-add-major-mode-key-based-replacements" ];
        diminish = [ "which-key-mode" ];
        defer = 3;
        config = "(which-key-mode)";
      };

      yaml-mode.enable = true;
    };
  };
}
