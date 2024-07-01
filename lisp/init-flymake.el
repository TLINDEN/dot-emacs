(use-package flymake
  :ensure nil

  :hook
  (sh-mode . flymake-mode)
  (shell-script-mode . flymake-mode)

  :custom
  (flymake-no-changes-timeout nil)
  (flymake-shellcheck-allow-external-files t)

  :init
  (defun tvd-flymake-install-hooks()
    (add-hook 'before-save-hook #'flymake-start))
  (defalias 'check-flymake 'consult-flymake)

  :bind
  ;;; ("!" . consult-flymake)

  :config
  (add-hook 'shell-script-mode-hook #'tvd-flymake-install-hooks))

(provide 'init-flymake)
;;; init-flymake.el ends here

