;; https://github.com/leoliu/ack-el

(defun tvd-kill-ack()
  "Close the  *ack* window and  kill the associated  buffer along
with the ack process"
  (interactive)
  (let ((kill-buffer-query-functions nil))
    (delete-window)
    (kill-buffer "*ack*")))

(defun tvd-hook-kill-ack()
  "set local keys in temporary ack buffer"
  (local-set-key (kbd "q") 'tvd-kill-ack))

(use-package ack
  :config

  ;; don't annoy me with git search & co
  (setq ack-defaults-function 'ack-legacy-defaults)

  ;; focus the *ack* buffer directly
  (advice-add 'ack-mode :after
              '(lambda ()
                 (pop-to-buffer "*ack*")))
  :init
  (add-hook 'ack-mode-hook 'tvd-hook-kill-ack))
