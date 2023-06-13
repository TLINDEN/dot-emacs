;; *** Markdown

;; I rarely use markdown, but sometimes I stumble upon such a file and
;; like    to    view    it     with    emacs    without    rendering.
;; Source: [[http://jblevins.org/projects/markdown-mode/][jblevins.org]]

;; via https://stackoverflow.com/a/26297700
(defun tvd-cleanup-org-tables ()
  (interactive)
  (when (equal major-mode 'markdown-mode)
    (save-excursion
      (goto-char (point-min))
      (while (search-forward "-+-" nil t) (replace-match "-|-")))))

(defun tvd-markdown-todo ()
  "Create dynamically highlighted TODO list of MD list"
  (interactive)
  (highlight-regexp "^- .*" "hi-yellow")
  (highlight-regexp "^- .*ok" "hi-green")
  (highlight-regexp "^- .*fail" "hi-pink"))

(defun tvd-markdown-cleanup()
  "Convert org  table into markdown  table if in  markdown-mode and
save the buffer [again], also check if parens are balanced"
  (when (equal major-mode 'markdown-mode)
    (when (check-parens)
      (tvd-cleanup-org-tables)
      (save-buffer))))

(use-package markdown-mode
  :mode "\\.text\\'"
  :mode "\\.markdown\\'"
  :mode "\\.md\\'"

  :config
  (modify-syntax-entry ?\" "\"" markdown-mode-syntax-table)

  (add-hook 'before-save-hook 'tvd-cleanup-org-tables)

  :hook
  (markdown-mode . orgalist-mode)
  (markdown-mode . orgtbl-mode))


(provide 'init-markdown)
;;; init-markdown.el ends here
