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
             (load-theme 'solarized-dark-high-contrast t))

;;; ** increase default font size on startup
(set-face-attribute 'default nil :height 133)

;; customize mode-line colors to have a little more contrast to the content
;; for reference, I used thes color codes as a base:
;; https://gist.github.com/ninrod/b0f86d77ebadaccf7d9d4431dd8e2983
;; and tweaked them in gimp a little
(set-face-background 'mode-line "#02161B") ;; base02 darkened
(set-face-foreground 'mode-line-inactive "#4d4d4d") ;; just grey
(set-face-background 'mode-line-inactive "#02161B")
