;; *** Highlighting Indentation
;; provides: highlight-indentation-mode and highlight-indentation-current-column-mode
(use-package highlight-indentation
             :config

             (add-something-to-mode-hooks
              '(yaml python ruby) 'highlight-indentation-current-column-mode)

             (set-face-background 'highlight-indentation-face "#e3e3d3")
             (set-face-background 'highlight-indentation-current-column-face "#c3b3b3"))


;;; ** global TAB/Indent config

;; I  use spaces  everywhere  but  Makefiles. If  I  encounter TABs  I
;; replace them with  spaces, if I encounter users  entering TABs into
;; files, I block them.

;; FIXME: also check [[https://github.com/glasserc/ethan-wspace][ethan-wspace]] !

;; TODO:  check for  side effects  when disabling  this. Currently  it
;; disturbs auto-fill in fundamental-mode, see also:
;; https://superuser.com/a/641778
;;; (setq indent-line-function 'insert-tab)


(setq tab-stop-list (quote (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120)))
(setq tab-always-indent 'complete) ; FIXME: doesnt work in cperl-mode
(setq show-trailing-whitespace t)

(defun indent-buffer ()
  ;; Author: Mathias Creutz
  "Re-Indent every line in the current buffer."
  (interactive)
  (indent-region (point-min) (point-max) nil))

;; Use normal tabs in makefiles
(add-hook 'makefile-mode-hook '(lambda() (setq indent-tabs-mode t)))



(provide 'init-indentation)
;;; init-indentation.el ends here
