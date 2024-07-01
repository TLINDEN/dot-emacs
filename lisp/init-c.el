;; *** C

(use-package c-mode
  :ensure nil ;; installed in site-lisp
  :defer nil

  :init
  (when (fboundp 'lsp-deferred)
    (defun lsp-c-install-save-hooks ()
      (add-hook 'before-save-hook #'lsp-format-buffer t t)
      (add-hook 'before-save-hook #'lsp-organize-imports t t))

    (add-hook 'c-mode-hook #'lsp-deferred)
    (add-hook 'c-mode-hook #'lsp-c-install-save-hooks)

    ;; c-mode sets TAB to 'c-indent-line-or-region by default which collides with corfu.
    (add-hook 'c-mode-hook (lambda () (define-key c-mode-map (kbd "<tab>") #'indent-for-tab-command)))))

(provide 'init-c)
;;; init-c.el ends here
