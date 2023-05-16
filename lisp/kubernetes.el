(defun tvd-kill-ro-buffer()
  (interactive)
  (when buffer-read-only
    (kill-buffer-and-window)))

(when nil
  (use-package kubel
           :after (vterm)
           :config (kubel-vterm-setup)
           :bind
           ("q" . tvd-kill-ro-buffer)))


(provide 'init-70-kubernetes)
;;; init-70-kubernetes.el ends here
