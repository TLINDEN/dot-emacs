;; https://github.com/leoliu/ack-el

(defun tvd-kill-ack()
  (interactive)
  (let ((kill-buffer-query-functions nil))
    (delete-window)
    (kill-buffer "*ack*")))

(defun tvd-hook-kill-ack()
  ;; FIXME: still asks!
  (local-set-key (kbd "q") 'tvd-kill-ack))

(use-package ack
  :config
  (setq ack-defaults-function 'ack-legacy-defaults)
  (advice-add 'ack-mode :after
    '(lambda ()
       (switch-to-buffer "*ack*"))))

(add-hook 'ack-mode-hook 'tvd-hook-kill-ack)
