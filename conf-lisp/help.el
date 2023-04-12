;; *** Help Mode

;; I even customize help windows! ... at least a little :)

(defun tvd-close-help ()
  (interactive)
  (kill-this-buffer)
  (winner-undo))

(eval-after-load "Help"
  '(progn
     (add-hook 'help-mode-hook
               (lambda ()
                 ; doesn' work the way I like
                 ;(local-set-key (kbd "q") 'tvd-close-help)
                 (local-set-key (kbd "q") 'quit-window)
                 (local-set-key (kbd "p") 'help-go-back)
                 (local-set-key (kbd "b") 'help-go-back)
                 (local-set-key (kbd "n") 'help-go-forward)
                 (local-set-key (kbd "f") 'help-go-forward)
                 (setq help-window-select t)
                 ))))
