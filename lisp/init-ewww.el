;; *** EWW browser stuff

;; Emacs has a builtin browser, which is not too bad.

(require 'eww)

;; see also: shr-render-[buffer|region] !
(defun eww-render-current-buffer ()
  "Render HTML in the current buffer with EWW"
  (interactive)
  (beginning-of-buffer)
  (eww-display-html 'utf8 (buffer-name)))

(defalias 'render-html 'eww-render-current-buffer)

;; eww config
(add-hook 'eww-mode-hook #'toggle-word-wrap)
(add-hook 'eww-mode-hook #'visual-line-mode)

;; custom short commands, see ? for the defaults
(define-key eww-mode-map "o" 'eww) ; aka other page
(define-key eww-mode-map "f" 'eww-browse-with-external-browser) ; aka firefox
(define-key eww-mode-map "j" 'next-line)
(define-key eww-mode-map "r" 'eww-reload)
(define-key eww-mode-map "s" 'shr-save-contents)
(define-key eww-mode-map "v" 'eww-view-source)
(define-key eww-mode-map "b" 'eww-add-bookmark)
(define-key eww-mode-map "p" 'eww-back-url)
(define-key eww-mode-map "n" 'eww-forward-url)

;; link short commands
(define-key eww-link-keymap "c" 'shr-copy-url)
(define-key eww-link-keymap "s" 'shr-save-contents)

;; FIXME:  latest GIT  version  of eww  contains 'eww-readable,  which
;; hides menus and distractions! Update emacs.


(provide 'init-ewww)
;;; init-ewww.el ends here
