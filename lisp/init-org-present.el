
(use-package org-present
  :config
  (defun tvd/org-present-prepare-slide (buffer-name heading)
    ;; Show only top-level headlines
    (org-overview)

    ;; Unfold the current entry
    (org-show-entry)

    ;; Show only direct subheadings of the slide but don't expand them
    (org-show-children))

  (defun tvd/org-present-start ()
    ;; Tweak font sizes
    (setq-local face-remapping-alist '((default (:height 1.5) variable-pitch)
                                       (header-line (:height 4.0) variable-pitch)
                                       (org-document-title (:height 1.75) org-document-title)
                                       (org-code (:height 1.55) org-code)
                                       (org-verbatim (:height 1.55) org-verbatim)
                                       (org-block (:height 1.25) org-block)
                                       (org-block-begin-line (:height 0.7) org-block)))

    ;; Set a blank header line string to create blank space at the top
    (setq header-line-format " ")

    ;; Display inline images automatically
    (org-display-inline-images)

    (org-present-read-only)

    (setq word-wrap t
          cursor-type nil
          line-spacing 5)

    (hide-mode-line-mode +1)

    ;; Center the presentation and wrap lines
    ;; (visual-fill-column-mode 1)
    ;; (visual-line-mode 1)

    (set-fringe-mode 0)
    (setq tvd/margin (/ (- (window-body-width) fill-column) 5))

    (org-superstar-mode)

    (set-window-margins nil tvd/margin tvd/margin))

  (defun tvd/org-present-end ()
    ;; Reset font customizations
    (setq-local face-remapping-alist '((default variable-pitch default)))

    ;; Clear the header line string so that it isn't displayed
    (setq header-line-format nil)

    ;; Stop displaying inline images
    (org-remove-inline-images)

    (org-present-show-cursor)
    (org-present-read-write)

    (setq word-wrap nil
          cursor-type t
          line-spacing nil)
    (hide-mode-line-mode -1)

    ;; Stop centering the document
    ;; (visual-fill-column-mode 0)
    ;; (visual-line-mode 0)

    (set-fringe-mode        1)
    (set-window-margins nil 0 0)

    (org-superstar-mode))

  ;; Turn on variable pitch fonts in Org Mode buffers
  (add-hook 'org-mode-hook 'variable-pitch-mode)

  ;; Register hooks with org-present
  (add-hook 'org-present-mode-hook 'tvd/org-present-start)
  (add-hook 'org-present-mode-quit-hook 'tvd/org-present-end)
  (add-hook 'org-present-after-navigate-functions 'tvd/org-present-prepare-slide)

  (define-key org-present-mode-keymap (kbd "q") 'org-present-quit)
  (define-key org-present-mode-keymap (kbd "<home>") 'org-present-top)
  (define-key org-present-mode-keymap (kbd "<end>") 'org-present-end))

(use-package visual-fill-column
  :config
  (setq visual-fill-column-width 110
      visual-fill-column-center-text t)
  )





(use-package hide-mode-line)

(use-package org-superstar)

(provide 'init-org-present)

