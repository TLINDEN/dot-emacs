;; *** web-mode (JS, HTML, CSS combined)

;; Web development is shit. Tech involved is a mess, and in most cases
;; intermixed.  web-mode provides  a great  fix for  this: it  handles
;; HTML, CSS and Javascript in the same buffer very well.

;; See: [[http://web-mode.org/][web-mode.org]]

(use-package web-mode
             :mode "\\.html\\'"
             :mode "\\.tpl\\'"
             :mode "\\.php\\'"
             :mode "\\.sp\\'"
             :mode "\\.erb\\'"
             :mode "\\.mustache\\'"
             :mode "\\.js\\'"

             :config
             (setq web-mode-markup-indent-offset 2)
             (setq web-mode-css-indent-offset 2)
             (setq web-mode-code-indent-offset 2)
             (setq web-mode-style-padding 1)
             (setq web-mode-script-padding 1)
             (setq web-mode-block-padding 0)
             (setq web-mode-enable-auto-pairing t)
             (setq web-mode-enable-auto-expanding t)

             ;; some handy html code inserters
             (defun html-insert-p()
               (interactive)
               (web-mode-element-wrap "p"))

             (defun html-insert-li()
               (interactive)
               (web-mode-element-wrap "li"))

             (defun html-insert-ul()
               (interactive)
               (web-mode-element-wrap "ul"))

             (defun html-insert-b()
               (interactive)
               (web-mode-element-wrap "b"))

             ;; convert a text list into a html list.
             (defun html-listify (beg end)
               (interactive "r")
               (save-excursion
                 (let* ((lines (split-string (buffer-substring beg end) "\n" t)))
                   (delete-region beg end)
                   (insert "<ul>\n")
                   (while lines
                     (insert "  <li>")
                     (insert (pop lines))
                     (insert "</li>\n"))
                   (insert "</ul>\n"))))
             )


(provide 'init-webmode)
;;; init-webmode.el ends here
