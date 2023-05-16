(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode)
  :mode "\\.py\\'"
  :hook
   (function
    (lambda()
      (local-set-key  [delete] 'py-electric-delete)
      (setq-default indent-tabs-mode nil)
      (setq mode-name "PY")
      (outline-minor-mode 0) ;; turn off outline here. FIXME: find out where it's turned on!
      )))


(provide 'init-python)
;;; init-python.el ends here
