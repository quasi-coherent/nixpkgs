;;; editor-init.el

(require 'use-package)
;;; Code:
(setq use-package-always-ensure 1)
(setq indent-tabs-mode nil)
(delete-selection-mode 1)

(use-package multiple-cursors
  :ensure t
  :bind (("M-n" . "mc/mark-next-like-this")
         ("M-p" . "mc/mark-previous-like-this"))
  :config
  (setq mc/always-run-for-all 1
        mc/cmds-to-run-once nil)
  )

(provide 'editor-init)
;;; editor-init.el ends here
