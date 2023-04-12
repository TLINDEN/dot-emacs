;; *** Markdown

;; I rarely use markdown, but sometimes I stumble upon such a file and
;; like    to    view    it     with    emacs    without    rendering.
;; Source: [[http://jblevins.org/projects/markdown-mode/][jblevins.org]]

;; via https://stackoverflow.com/a/26297700
(defun tvd-cleanup-org-tables ()
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "-+-" nil t) (replace-match "-|-"))
    ))

(defun tvd-markdown-todo ()
  "Create dynamically highlighted TODO list of MD list"
  (interactive)
  (highlight-regexp "^- .*" "hi-yellow")
  (highlight-regexp "^- .*ok" "hi-green")
  (highlight-regexp "^- .*fail" "hi-pink"))

(use-package markdown-mode
             :mode "\\.text\\'"
             :mode "\\.markdown\\'"
             :mode "\\.md\\'"

             :config
             (defun tvd-markdown-hooks ()
               (when buffer-file-name
                 (add-hook 'after-save-hook
                           'check-parens
                           nil t)
                 (add-hook 'after-save-hook 'tvd-cleanup-org-tables  nil 'make-it-local))

               (modify-syntax-entry ?\" "\"" markdown-mode-syntax-table)

               (when (fboundb 'orgtbl-mode)
                 (add-hook 'markdown-mode-hook 'orgtbl-mode)))

             :hook tvd-markdown-hooks
             )
