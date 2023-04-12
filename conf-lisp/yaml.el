;; *** Yaml Mode

(use-package yaml-mode
             :mode "\\.yml\\'"
             :mode "\\.yaml\\'"
             :mode "\\.j2\\'"

             :config
             (defun yaml-point-in-comment-p ()
               "Test if character at cursor is a comment."
               (interactive)
               (save-excursion
                 (right-char) ; visible cursor position needed
                 (nth 4 (syntax-ppss))))

             (defun yaml-goto-beginning()
               "Move cursor to beginning of yaml key on current line"
               (interactive)
               (beginning-of-line)
               (skip-chars-forward " "))

             (defun yaml-next-block()
               "Jump to the next yaml block with the same indent as the current one"
               (interactive)
               (yaml-goto-beginning)
               (next-line)
               (while (or (looking-at " ") (yaml-point-in-comment-p))
                 (next-line))
               (yaml-goto-beginning))

             (defun yaml-prev-block()
               "Jump to the previous yaml block with the same indent as the current one"
               (interactive)
               (yaml-goto-beginning)
               (previous-line)
               (while (or (looking-at " ") (yaml-point-in-comment-p))
                 (previous-line))
               (yaml-goto-beginning))

             (defun yaml-level-down()
               "Jump down to the next yaml child block"
               (interactive)
               (yaml-goto-beginning)
               (next-line)
               (while (or (not (looking-at " ")) (yaml-point-in-comment-p))
                 (next-line))
               (skip-chars-forward " "))

             (defun yaml-level-up()
               "Jump up to the next yaml parent block"
               (interactive)
               (yaml-goto-beginning)
               (left-char)
               (previous-line)
               (while (or (looking-at " ") (yaml-point-in-comment-p))
                 (previous-line))
               (yaml-goto-beginning))

             (define-key yaml-mode-map "\C-m" 'newline-and-indent)

             ;; works, but then <tab> cannot be used for re-indenting :(
             ;; (outline-minor-mode)
             ;; (define-key yaml-mode-map (kbd "TAB") 'outline-toggle-children)
             ;; (setq outline-regexp "^ *\\([A-Za-z0-9_-]*: *[>|]?$\\|-\\b\\)")
             (define-key smartparens-mode-map (kbd "<C-right>") nil)
             (define-key smartparens-mode-map (kbd "<C-left>") nil)

             (define-key yaml-mode-map (kbd "<C-down>")  'yaml-next-block)
             (define-key yaml-mode-map (kbd "<C-up>")    'yaml-prev-block)
             (define-key yaml-mode-map (kbd "<C-right>") 'yaml-level-down)
             (define-key yaml-mode-map (kbd "<C-left>") 'yaml-level-up))
