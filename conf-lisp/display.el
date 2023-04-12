;;; Display settings

;; better visibility of cursor in console sessions
(unless (display-graphic-p)
  ;; instead of closing the terminal, just kill the buffer
  (global-set-key (kbd "C-x c") 'kill-this-buffer)
  (set-face-attribute 'fringe nil :inverse-video t)
  (invert-face 'default)
  (invert-face 'mode-line))

(use-package solarized-theme
             :ensure t
             :config
             (load-theme 'solarized-dark t))

;;; ** increase default font size on startup
(set-face-attribute 'default nil :height 133)
