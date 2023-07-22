;; maintain daemon.de jekyll website

;; (require 'subr-x)
(setq daemon-de-site  "~/dev/web/daemon.de")

(setq daemon-de-template "---
layout: post
title: %s
tags:
- %s
---


")

(defun daemon-de-title2slug(title)
  (interactive)
  (concat
   (format-time-string "%Y-%m-%d-")
   (replace-regexp-in-string "[[:nonascii:]]" "" (replace-regexp-in-string " " "-" (downcase title)))
   ".md"))

(defun daemon-de-new-blogpost(title category)
  "Create a new blog posting for daemon.de"
  (interactive "sEnter blog post title: \nsEnter a category: ")
  (find-file
   (format "%s/_posts/%s" daemon-de-site (daemon-de-title2slug title)))
  (insert (format daemon-de-template title category))
  )

(defun --daemon-de-new-blogpost(title category)
  "Create a new blog posting for daemon.de"
  (interactive "sEnter blog post title: \nsEnter a category: ")
  (let ((cwd default-directory)
        (path ""))
    (cd daemon-de-site)
    (find-file
     (string-trim-right
      (shell-command-to-string
       (format "./newblog.sh '%s' '%s'" title category))))
    (cd cwd)))

(defun daemon-de-publish()
  "build and publish jekyll site using git"
  (interactive)
  (magit-status daemon-de-site))

(provide 'init-daemonde)
;;; init-daemonde.el ends here
