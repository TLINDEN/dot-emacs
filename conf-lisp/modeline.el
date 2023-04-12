;; ** mode-line setup (must be the last mode)

;; I just append the current version  of my emacs config and leave out
;; some stuff  to keep the modeline  short, so that everything  can be
;; seen even if I have multiple windows open.

;; smaller pos
(setq-default mode-line-position
              '((-3 "%p") (size-indication-mode ("/" (-4 "%I")))
                " "
                (line-number-mode
                 ("%l" (column-number-mode ":%c")))))

;; when macro recording is active,  signal it with coloring instead of
;; just a character
(defface rec-face
  '((t (:background "red" :foreground "white" :weight bold)))
  "Flag macro recording in mode-line"
  :group 'tvd-mode-line-faces)

;; custom modeline
(setq-default mode-line-format
              (list
               "%e"
               mode-line-front-space
               mode-line-mule-info
               mode-line-modified
               mode-line-remote
               "  "
               mode-line-buffer-identification
               "  "
               mode-line-position
               " (%m) "

               " [" tvd-emacs-version "] "

               ; added because of eyebrowse
               mode-line-misc-info

               '(:eval (propertize
                        (if (eq defining-kbd-macro t)
                            "[REC]"
                          "")
                        'face 'rec-face))

               mode-line-end-spaces))
