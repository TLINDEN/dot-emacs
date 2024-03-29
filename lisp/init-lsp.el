;; LSP mode
(use-package lsp-mode
  :config
  (lsp-register-custom-settings
   '(("gopls.completeUnimported" t t)
     ("gopls.staticcheck" t t)))

  ;; disable infantile nonsense
  (setq lsp-headerline-breadcrumb-enable nil
        lsp-modeline-code-actions-enable nil)

  :init
  ;; I'm not using any of th  lsp commands, but better define a prefix
  ;; than being unable to reach it
  ;; FIXME: add at least lsp-find-definition
  (setq lsp-keymap-prefix "C-c C-l")

  :commands lsp)

;; I use ivy
;; (use-package lsp-ivy
;;   :commands lsp-ivy-global-workspace-symbol)


(provide 'init-lsp)
;;; init-lsp.el ends here
