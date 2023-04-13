;; *** Go Lang

(use-package go-mode
             :mode "\\.go\\'"
             :mode "\\.mod\\'"

             :config
             (setq gofmt-args '("-s"))
             (setq tab-width 4)
             ;; (setq indent-tabs-mode 1)

             :init
             (add-hook 'before-save-hook 'gofmt-before-save))
