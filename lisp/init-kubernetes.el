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


(provide 'init-kubernetes)
;;; init-kubernetes.el ends here
