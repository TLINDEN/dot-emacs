;; *** conf-mode

;; conf-mode annoyingly overwrites the  global keybinding C-c C-c with
;; some of its internal crab. So, force  it to use my own defun. Also,
;; while  we're  at it,  disable  electric  indent, it's  annoying  in
;; configs. Applies for derivates as well.

(defun tvd-disarm-conf-mode()
  (local-set-key  (kbd "C-c C-c") 'comment-or-uncomment-region-or-line)
  (electric-indent-local-mode 0))

(add-something-to-mode-hooks '(conf cisco fundamental conf-space pod) 'tvd-disarm-conf-mode)


(provide 'init-conf)
;;; init-conf.el ends here
