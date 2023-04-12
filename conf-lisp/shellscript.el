;; *** Shell-Script Mode

;; C-c C-c [un-]comments everywhere, force in shell-script-mode as well
(add-hook
 'sh-mode-hook
 (function
  (lambda()
    (local-set-key (kbd "C-c C-c")  'comment-or-uncomment-region-or-line))))
