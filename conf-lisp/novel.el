;; *** Novel Mode - Screen Reader

;; my own emacs screen reader, very handy to read docs on the road.

(use-package novel-mode
             :ensure nil
             :config
             (global-set-key (kbd "C-c C-n")         'novel-mode))
