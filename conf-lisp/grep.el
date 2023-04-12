;; https://github.com/leoliu/ack-el

(defun tvd-kill-ack()
  ;; FIXME: still asks!
  (local-set-key (kbd "q") 'kill-buffer-and-window))

(use-package ack
  :config
  (setq ack-defaults-function 'ack-legacy-defaults))

(add-hook 'ack-mode-hook 'tvd-kill-ack)
