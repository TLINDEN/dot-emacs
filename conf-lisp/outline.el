;; *** outline mode

;; I use the very same cycle style  as in org mode: when on a heading,
;; hide it, jump to next heading on the same level and expand that (or
;; vice versa).  however, when NOT on  a heading behave as loved: jump
;; paragraphs.

;; Note, that  this also  affects outshine  mode, since  that inherits
;; from outline.

(defun tvd-outline-left-or-level-up()
  "jump one word to the left if not on a heading,
otherwise fold current level and jump one level up."
  (interactive)
  (if (outline-on-heading-p)
      (progn
        (hide-subtree)
        (outline-up-heading 1))
    (left-word)))

(defun tvd-outline-heading-up()
  "fold current heading, jump one level up and unfold it"
  (interactive)
  (if (not (outline-on-heading-p))
      (backward-paragraph)
    (hide-subtree)
    (outline-backward-same-level 1)
    (outline-cycle)))

(defun tvd-outline-heading-down()
  "fold current heading, jump one level down and unfold it"
  (interactive)
  (if (not (outline-on-heading-p))
      (forward-paragraph)
    (hide-subtree)
    (outline-forward-same-level 1)
    (outline-cycle)))

;; unused, see tvd-outshine-jump
(defun tvd-outline-jump (part)
  "Jump interactively to next header containing PART using search."
  (interactive "Mjump to: ")
  (let ((done nil)
        (pwd (point)))
    (beginning-of-buffer)
    (outline-show-all)
    (when (re-search-forward (format "^;; \\*+.*%s" part) (point-max) t)
      (when (outline-on-heading-p)
        (beginning-of-line)
        (setq done t)))
    (when (not done)
      (message (format "no heading with '%s' found" part))
      (goto-char pwd))))

;; outline mode config
(eval-after-load "outline"
  '(progn
     (add-hook 'outline-minor-mode-hook
               (lambda ()
                 ;; narrowing, we use outshine functions, it's loaded anyway
                 (defalias 'n 'outshine-narrow-to-subtree)
                 (defalias 'w 'widen)
                 (define-key outline-minor-mode-map (kbd "<C-up>")   'tvd-outline-heading-up)
                 (define-key outline-minor-mode-map (kbd "<C-down>") 'tvd-outline-heading-down)
                 ;;(define-key outline-minor-mode-map (kbd "<C-left>") 'tvd-outline-left-or-level-up)
                 ))))

;; orange fringe when narrowed
(advice-add 'outshine-narrow-to-subtree :after
            '(lambda (&rest args)
               (set-face-attribute 'fringe nil :background tvd-fringe-narrow-bg)))

