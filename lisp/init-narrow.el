;; *** narrowing (no mode but fits here)

;; I use narrowing quite frequently, so here are some enhancements.

;; easier narrowing with Indirect Buffers
;; Source: [[https://www.emacswiki.org/emacs/NarrowIndirect3][emacswiki]]
(require 'narrow-indirect)
(defalias 'nf 'ni-narrow-to-defun-indirect-other-window)
(defalias 'nr 'ni-narrow-to-region-indirect-other-window)

;; I  like to  have  an  orange fringe  background  when narrowing  is
;; active, since I forget that it is in effect otherwise sometimes.

;; via [[https://emacs.stackexchange.com/questions/33288/how-to-find-out-if-narrow-to-region-has-been-called-within-save-restriction][stackoverflow]]
(defun tvd-narrowed-fringe-status ()
  "Make the fringe background reflect the buffer's narrowing status."
  (set-face-attribute
   'fringe nil :background (if (buffer-narrowed-p)
                               tvd-fringe-narrow-bg
                             nil)))

(add-hook 'post-command-hook 'tvd-narrowed-fringe-status)


(provide 'init-narrow)
;;; init-narrow.el ends here
