;; *** rust  mode
(use-package rust-mode
             :config

             (defun rustlings-done ()
               "I use this with rustlings"
               (interactive)
               (search-backward "DONE")
               (move-beginning-of-line 1)
               (kill-line)
               (save-buffer))

             :mode "\\.rs\\'")
