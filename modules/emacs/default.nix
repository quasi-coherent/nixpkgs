{ config, pkgs, inputs, nur-no-pkgs, ... }:

{
  imports = [ nur-no-pkgs.repos.rycee.hmModules.emacs-init ];

  programs.emacs.package = pkgs.emacs;
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
      (put 'minibuffer-history 'history-length 100)
      (put 'kill-ring 'history-length 25)

      ;; Global key bindings
      (global-set-key (kbd "C-x C-b") 'ibuffer)
      (global-set-key (kbd "C-<return>") 'toggle-frame-fullscreen)
      (global-set-key (kbd "C-<backspace>") (lambda ()
                      (interactive)
                      (kill-line 0)
                      (indent-according-to-mode)))

      (setq user-full-name "Daniel Donohue"
            user-login-name "Daniel Donohue"
            user-mail-address "d.michael.donohue@gmail.com"
            inhibit-startup-screen t
            inhibit-startup-echo-area-message (user-login-name)
            make-backup-files nil
            create-lockfiles nil
            backup-directory-alist `((".*" . ,temporary-file-directory))
            auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

      ;; Default values
      (setq-default
       ring-bell-function 'ignore
       history-length 100
       ad-redefinition-action 'accept
       cursor-in-non-selected-windows nil
       display-time-default-load-average nil
       fill-column 80
       show-trailing-whitespace 1
       inhibit-startup-screen 1
       inhibit-scratch-message ""
       inhibit-startup-echo-area-message (user-login-name)
       confirm-nonexistent-file-or-buffer 1
       kill-ring-max 128
       load-prefer-newer 1
       mark-ring-max 128
       make-backup-files nil
       create-lockfiles nil
       scroll-conservatively most-positive-fixnum
       view-read-only 1
       user-full-name "Daniel Donohue"
       user-mail-address "d.michael.donohue@gmail.com"
       use-package-always-ensure 1
       indent-tabs-mode nil
      )

      (fset 'yes-or-no-p 'y-or-n-p)

      (global-display-line-numbers-mode 1)
      (global-hl-line-mode 1)
      (column-number-mode 1)
      (delete-selection-mode 1)
      (global-auto-revert-mode 1)
      (show-paren-mode 1)

      ;; Global hooks
      (add-hook 'before-save-hook 'delete-trailing-whitespace)

      ;; Functions
      (defun dmd/cleanup-lsp ()
        "Remove all the workspace folders from LSP"
        (interactive)
        (let ((folders (lsp-session-folders (lsp-session))))
          (while folders
            (lsp-workspace-folders-remove (car folders))
            (setq folders (cdr folders)))))
    '';

    usePackage = {

      ##### UI

      doom-modeline = {
        enable = true;
        init = "(doom-modeline-mode 1)";
        config = ''
          (setq doom-modeline-buffer-file-name-style 'relative-from-project
                doom-modeline-icon nil
                doom-modeline-major-mode-icon nil)
        '';
      };

      git-gutter-fringe = {
        enable = true;
        init = "(global-git-gutter-mode 1)";
      };

      hemisu-theme = {
        enable = true;
        init = "(load-theme 'hemisu-dark 1)";
      };

      ##### Windows

      ace-window = {
        enable = true;
        bind = {
          "C-x o" = "ace-window";
        };
        config = "(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))";
      };

      ##### Buffers

      avy = {
        enable = true;
        bind = {
          "C-c j" = "avy-goto-word-or-subword-1";
        };
        config = "(setq avy-all-windows t)";
      };

      move-text = {
        enable = true;
        bind = {
          "M-<up>" = "move-text-up";
          "M-<down>" = "move-text-down";
        };
        config = "(move-text-default-bindings)";
      };

      multiple-cursors = {
        enable = true;
        bind = {
          "C-S-c C-S-c" = "mc/edit-lines";
          "C-c m" = "mc/mark-all-like-this";
          "C->" = "mc/mark-next-like-this";
          "C-<" = "mc/mark-previous-like-this";
        };
        config = ''
          (setq mc/always-run-for-all 1
                mc/cmds-to-run-once nil)
        '';
      };

      smartparens = {
        enable = true;
        diminish = [ "smartparens-mode" ];
        bindLocal.smartparens-mode-map = {
          "M-<right>" = "sp-forward-sexp";
          "M-<left>" = "sp-backward-sexp";
        };
        config = ''
          (smartparens-global-mode 1)
          (show-smartparens-global-mode 1)
        '';
      };

      ##### Files

      autorevert = {
        enable = true;
        diminish = [ "auto-revert-mode" ];
        bind = {
          "C-x R" = "revert-buffer";
        };
        config = "(global-auto-revert-mode 1)";
      };

      dired = {
        enable = true;
        command = [ "dired dired-jump" ];
        bindLocal = {
          dired-mode-map = {
            "C-x C-d" = "#'dired-jump";
          };
        };
      };

      dired-subtree = {
        enable = true;
        after = [ "dired" ];
        bindLocal = {
          dired-mode-map = {
            "<tab>" = "dired-subtree-toggle";
            "<backspace>" = "dired-subtree-cycle";
          };
        };
      };

      ##### Minibuffer

      consult = {
        enable = true;
        after = [ "vertico "];
        bind = {
          "C-s" = "consult-line";
          "C-x b" = "consult-buffer";
          "M-g f" = "consult-flycheck";
          "M-g g" = "consult-goto-line";
          "M-g M-g" = "consult-goto-line";
          "M-g i" = "consult-imenu";
          "M-s f" = "consult-fd";
          "M-s g" = "consult-git-grep";
          "M-s r" = "consult-ripgrep";
          "M-s L" = "consult-line-multi";
        };
        bindLocal = {
          minibuffer-local-map = {
            "M-s" = "consult-history";
            "M-r" = "consult-history";
          };
        };
        config = ''
          (setq consult-narrow-key "<")

          (defvar dmd/consult-line-map
            (let ((map (make-sparse-keymap)))
              (define-key map "\C-s" #'vertico-next)
              map))
        '';
      };

      consult-dir = {
        enable = true;
        after = [ "vertico "];
        bind = {
          "C-x C-d" = "consult-dir";
        };
        bindLocal.vertico-map = {
          "C-x C-d" = "consult-dir";
          "C-x C-j" = "consult-dir-jump-file";
        };
        extraConfig = ''
          :custom
          (consult-dir-project-list-function nil)
        '';
      };

      consult-projectile = {
        enable = true;
        after = [ "consult" "projectile" ];
        command = [ "consult-projectile" ];
      };

      consult-yasnippet = {
        enable = true;
        command = [ "consult-yasnippet" ];
      };

      company = {
        enable = true;
        command = [ "company-mode" "company-doc-buffer" "global-company-mode" ];
        defer = 1;
        extraConfig = ''
          :bind (:map company-mode-map
                      ([remap completion-at-point] . company-complete-common)
                      ([remap complete-symbol] . company-complete-common))
        '';
        config = ''
          (setq company-idle-delay 0.3
                company-show-quick-access t
                company-tooltip-maximum-width 100
                company-tooltip-minimum-width 20
                company-require-match nil)

          (global-company-mode)
        '';
      };

      embark = {
        enable = true;
        bind = {
          "C-." = "embark-act";
          "M-." = "embark-dwim";
          "C-h B" = "embark-bindings";
        };
        init = ''
          (setq prefix-help-command #'embark-prefix-help-command)
        '';
        config = ''
          (setq embark-indicators '(embark-minimal-indicator
                                    embark-highlight-indicator
                                    embark-isearch-highlight-indicator))
        '';
      };

      embark-consult = {
        enable = true;
        hook = [ "(embark-collect-mode . consult-preview-at-point)" ];
      };

      marginalia = {
        enable = true;
        after = [ "vertico" ];
        config = "(marginalia-mode)";
        extraConfig = ''
          :custom
          (marginalia-annotators '(marginalia-annotators-heavy
                                   marginalia-annotators-light
                                   nil))
        '';
      };

      orderless = {
        enable = true;
        demand = true;
        config = "(setq completion-styles '(orderless basic))";
      };

      vertico = {
        enable = true;
        demand = true;
        bindLocal.vertico-map = {
          "<return>" = "vertico-directory-enter";
          "<backspace>" = "vertico-directory-delete-char";
          "M-<backspace>" = "vertico-directory-delete-word";
        };
        config = "(vertico-mode)";
      };

      vertico-directory = {
        enable = true;
        after = [ "vertico" ];
      };

      wgrep = {
        enable = true;
        after = [ "consult" ];
        hook = ["(grep-mode . wgrep-setup)"];
      };

      ##### Development

      envrc = {
        enable = true;
        hook = ["(after-init . envrc-global-mode)"];
      };

      magit = {
        enable = true;
        diminish = [ "auto-revert-mode" ];
        command = [ "magit-status" ];
        bind = {
          "C-c C-g" = "magit-status";
        };
      };

      projectile = {
         enable = true;
         diminish =  [ "projectile-mode" ];
         init = "(projectile-mode)";
         bindKeyMap = {
           "C-c C-p" = "projectile-command-map";
         };
         config = ''
           (setq projectile-enable-caching t
                 projectile-switch-project-action #'projectile-dired)
         '';
       };

      ##### LSP

      consult-lsp = {
        enable = true;
        after = [ "consult" "lsp" "xref" ];
        command = [
          "consult-lsp-diagnostics"
          "consult-lsp-file-symbols"
          "consult-lsp-symbols"
        ];
        extraConfig = ''
          :bind (:map lsp-mode-map
                      ([remap xref-find-apropos] . consult-lsp-symbols))
        '';
      };

      consult-xref = {
        enable = true;
        after = [ "consult" "xref" ];
        command = [ "consult-xref" ];
        init = ''
          (setq xref-show-definitions-function #'consult-xref
                xref-show-xrefs-function #'consult-xref)
        '';
      };

      eldoc = {
        enable = true;
        command = [ "eldoc-mode" ];
      };

      flycheck = {
        enable = true;
        command = [ "global-flycheck-mode" ];
        defer = 1;
        diminish = [ "flycheck-mode" ];
        bind = {
          "M-n" = "flycheck-next-error";
          "M-p" = "flycheck-previous-error";
        };
        config = ''
          (setq flycheck-check-syntax-automatically '(mode-enabled save))
          (global-flycheck-mode)
        '';
      };

      lsp-completion = {
        enable = true;
        after = [ "lsp-mode" ];
        config = ''
          (setq lsp-completion-enable-additional-text-edit nil)
          (lsp-completion-mode)
        '';
      };

      lsp-diagnostics = {
        enable = true;
        after = [ "lsp-mode" ];
      };

      lsp-mode = {
        enable = true;
        after = [ "company" "flycheck" ];
        command = [ "lsp" "lsp-deferred" ];
        hook = [ "(lsp-mode . lsp-enable-which-key-integration)" ];
        init = ''
          (setq lsp-keymap-prefix "C-l l")
        '';
        config = ''
          (setq lsp-diagnostics-provider :flycheck
                lsp-modeline-diagnostics-scope :workspace
                lsp-lens-enable t
                lsp-eldoc-render-all nil
                lsp-auto-guess-root nil
                lsp-prefer-flymake nil
                lsp-headliner-breadcrumb-enable nil
                lsp-modeline-code-actions-enable nil
                lsp-enable-on-type-formatting nil)
        '';
      };

      lsp-lens = {
        enable = true;
        after = [ "lsp-mode" ];
        command = [ "lsp-lens--enable" ];
      };

      lsp-modeline = {
        enable = true;
        after = [ "lsp-mode" ];
      };

      lsp-ui = {
        enable = true;
        after = [ "lsp-mode" ];
        command = [ "lsp-ui-mode" ];
        bindLocal = {
          lsp-mode-map = {
            "C-l l u d" = "lsp-ui-doc-glance";
            "C-l l u s" = "lsp-ui-find-workspace-symbol";
          };
        };
        config = ''
          (setq lsp-ui-sideline-enable t
                lsp-ui-sideline-show-symbol nil
                lsp-ui-sideline-show-hover nil
                lsp-ui-sideline-show-code-actions nil
                lsp-ui-sideline-update-mode 'point
                lsp-ui-doc-enable nil
                lsp-ui-doc-position 'at-point
                lsp-ui-doc-max-width 120
                lsp-ui-doc-max-height 15)
        '';
      };

      lsp-ui-flycheck = {
        enable = true;
        after = [ "flycheck" "lsp-ui" ];
      };

      yasnippet = {
        enable = true;
        command = [ "yas-global-mode" "yas-minor-mode" "yas-expand-snippet" ];
        config = "(yas-global-mode)";
      };

      ##### Languages

      lsp-bash = {
        enable = true;
        hook = ["(sh-mode . lsp-deferred)"];
      };

      dockerfile-mode = {
        enable = true;
        mode = [''("^Dockerfile\\'" . go-mode)''];
      };

      lsp-dockerfile = {
        enable = true;
        hook = ["(dockerfile-mode . lsp-deferred)"];
      };

      go-mode = {
        enable = true;
        mode = [''("\\.go\\'" . go-mode)''];
        hook = ["(go-mode . subword-mode)"];
        config = ''
          (setq indent-tabs-mode 1
                tab-width 4)
        '';
      };

      lsp-go = {
        enable = true;
        hook = [
          "(go-mode . lsp-deferred)"
          "(go-mode 'dmd/lsp-go-install-save-hooks)"
       ];
        config = ''
          (defun dmd/lsp-go-install-save-hooks ()
             (add-hook 'before-save-hook #'lsp-format-buffer t t)
             (add-hook 'before-save-hook #'lsp-organize-imports t t))
        '';
      };

      haskell-mode = {
        enable = true;
        mode = [ ''("\\.hs\\'" . haskell-mode)'' ];
        hook = [ "(haskell-mode . subword-mode)" ];
        config = "(setq tab-width 2)";
      };

      lsp-haskell = {
        enable = true;
        hook = [ "(haskell-mode . lsp-deferred)" ];
      };

      lsp-java = {
        enable = true;
        hook = ["(java-mode . lsp-deferred)"];
        config = "(setq lsp-java-save-actions-organize-imports t)";
      };

      json-mode = {
        enable = true;
        mode = [ ''("\\.json\\'" . json-mode)'' ];
      };

      lsp-json = {
        enable = true;
        hook = [
          "(json-mode . lsp-deferred)"
          "(before-save . json-pretty-print-buffer)"
        ];
      };

      lisp-mode = {
        enable = true;
        mode = [ ''("\\.el\\'" . lisp-mode)'' ];
      };

      markdown-mode = {
        enable = true;
        mode = [ ''("\\.md\\'" . markdown-mode)'' ];
      };

      lsp-marksman = {
        enable = true;
        hook = [ "(markdown-mode . lsp-deferred)" ];
      };

      nix-mode = {
        enable = true;
        mode = [ ''("\\.nix\\'" . nix-mode)'' ];
        hook = [ "(nix-mode . subword-mode)" ];
      };

      lsp-nix = {
        enable = true;
        hook = [ "(nix-mode . lsp-deferred)" ];
        config = ''(setq lsp-nix-nil-formatter ["nixfmt"])'';
      };

      python-mode = {
        enable = true;
        mode = [ ''("\\.py\\'" . python-mode)'' ];
        hook = [ "(python-mode . subword-mode)" ];
        config = ''
          (setq tab-width 4)
          (setq py-indent-offset 4)
        '';
      };

      lsp-pyright = {
        enable = true;
        hook = [ "(python-mode . lsp-deferred)" ];
      };

      rust-mode = {
        enable = true;
        mode = [ ''("\\.rs\\'" . rust-mode)'' ];
        hook = [ "(rust-mode . subword-mode)" ];
      };

      rustic = {
        enable = true;
        hook = [ "(rust-mode . lsp-deferred)" ];
        config = ''
          (setq lsp-rust-analyzer-proc-macro-enable t
                rustic-cargo-fmt t
                rustic-format-trigger 'on-save
                rustic-format-display-method 'ignore)
        '';
        extraConfig = ''
          :custom
          (rustic-rustfmt-config-alist '((edition . "2021")))
        '';
      };

      scala-mode = {
        enable = true;
        mode = [ ''("\\.scala\\'" . scala-mode)'' ];
        hook = [ "(scala-mode . subword-mode)" ];
      };

      lsp-metals = {
        enable = true;
        hook = [ "(scala-mode . lsp-deferred)" ];
        config = ''
          (setq lsp-metals-server-args '("-J-Dmetals.allow-multiline-string-formatting=off"))
        '';
      };

      sqlformat = {
        enable = true;
        mode = [ ''("\\.sql\\'" . sql-mode)'' ];
        hook = [ "(sql-mode . sqlformat-on-save-mode)" ];
        config = ''
          (setq sqlformat-command 'pgformatter
                sqlformat-args '("-s2" "-g"))
        '';
      };

      lsp-sqls = {
        enable = true;
        hook = [
          "(sql-mode . lsp-deferred)"
          "(sql-mode . subword-mode)"
        ];
        config = "(setq lsp-sqls-workspace-config-path nil)";
      };

      terraform-mode = {
        enable = true;
        mode = [ ''("\\.tf\\'" . terraform-mode)'' ];
        hook = [ "(terraform-mode . subword-mode)" ];
      };

      typescript-mode = {
        enable = true;
        mode = [ ''("\\.tsx?$" . typescript-mode)'' ];
        hook = [ "(typescript-mode . lsp-deferred)" ];
        config = "(setq typescript-indent-level 2)";
      };

      yaml-mode = {
        enable = true;
        mode = [ ''("\\.yaml\\'" . yaml-mode)'' ];
      };

      lsp-yaml = {
        enable = true;
        hook = [ "(yaml-mode . lsp-deferred)" ];
        config = "(setq lsp-yaml-completion t)";
      };

      ##### Tools

      ediff = {
        enable = true;
        defer = true;
        config = ''
          (setq ediff-window-setup-function 'ediff-setup-windows-plain)
        '';
      };

      time = {
        enable = true;
        init = ''
          (setq display-time-24hr-format 1
                display-time-day-and-date 1
                display-time-interval 10)
        '';
        config = "(display-time)";
      };

      which-key = {
        enable = true;
        command = [ "which-key-mode" "which-key-add-major-mode-key-based-replacements" ];
        diminish = [ "which-key-mode" ];
        config = "(which-key-mode)";
      };
    };
  };
}
