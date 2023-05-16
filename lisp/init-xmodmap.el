;; *** Xmodmap Mode

;; the shortest mode ever, [[https://www.emacswiki.org/emacs/XModMapMode][via emacswiki]].

(define-generic-mode 'xmodmap-mode
  '(?!)
  '("add" "clear" "keycode" "keysym" "pointer" "remove")
  '(("[0-9]+" . 'font-lock-variable-name-face))
  '("[xX]modmap\\(rc\\)?\\'")
  nil
  "Simple mode for xmodmap files.")


(provide 'init-xmodmap)
;;; init-xmodmap.el ends here
