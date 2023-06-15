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

;; via https://endlessparentheses.com/emacs-narrow-or-widen-dwim.html
;; pure genius, never ever have to think about how to widen
(defun narrow-or-widen-dwim (p)
  "Widen if buffer is narrowed, narrow-dwim otherwise.
Dwim means: region, org-src-block, org-subtree, or
defun, whichever applies first. Narrowing to
org-src-block actually calls `org-edit-src-code'.

With prefix P, don't widen, just narrow even if buffer
is already narrowed."
  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
        ((region-active-p)
         (narrow-to-region (region-beginning)
                           (region-end)))
        ((derived-mode-p 'org-mode)
         ;; `org-edit-src-code' is not a real narrowing
         ;; command. Remove this first conditional if
         ;; you don't want it.
         (cond ((ignore-errors (org-edit-src-code) t)
                (delete-other-windows))
               ((ignore-errors (org-narrow-to-block) t))
               (t (org-narrow-to-subtree))))
        ((derived-mode-p 'latex-mode)
         (LaTeX-narrow-to-environment))
        (t (narrow-to-defun))))

;; This line actually replaces Emacs' entire narrowing
;; keymap, that's how much I like this command. Only
;; copy it if that's what you want.
(define-key ctl-x-map "n" #'narrow-or-widen-dwim)


(provide 'init-narrow)
;;; init-narrow.el ends here
