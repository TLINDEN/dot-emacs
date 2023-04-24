;; *** Go Lang

(use-package go-mode
             :mode "\\.go\\'"
             :mode "\\.mod\\'"

             :config
             (setq gofmt-args '("-s"))
             (setq tab-width 4)
             ;; (setq indent-tabs-mode 1)

             :init
             ;; disabled, I'm now trying lsp-mode, see below:
             ;; (add-hook 'before-save-hook 'gofmt-before-save)
             ;;   :hook (go-mode lsp-deferred)

             (when (fboundp 'lsp-deferred)
               (defun lsp-go-install-save-hooks ()
                 (add-hook 'before-save-hook #'lsp-format-buffer t t)
                 (add-hook 'before-save-hook #'lsp-organize-imports t t))

               (add-hook 'go-mode-hook #'lsp-deferred)
               (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)
               (add-hook 'go-mode-hook #'ivy-mode)

               ;; overwrite dump-jump settions here
               (bind-key*  (kbd "C-c j") #'lsp-find-definition)
               (bind-key*  (kbd "C-c b") #'xref-pop-marker-stack)
               ))
