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

(when nil
  ;; from https://lists.gnu.org/archive/html/bug-gnu-emacs/2021-02/msg00885.html
  ;; compiles but doesn't work
  (defvar ml-text-scale-factor 1.0
    "Ratio of mode-line text size to default text size, as a float.
This is needed to make sure the text is properly aligned.")

  (defun ml-fill-to-center (reserve face)
    "Return empty space to the center, leaving RESERVE space on the right."
    (setq reserve (* ml-text-scale-factor reserve))
    (propertize " "
                'display `((space :align-to (- (+ center (.5 . right-margin))
                                               ,reserve
                                               (.5 . left-margin))))
                'face face))

  (defun ml-fill-to-right (reserve face)
    "Return empty space, leaving RESERVE space on the right."
    (setq reserve (* ml-text-scale-factor reserve))
    (when (and window-system (eq 'right (get-scroll-bar-mode)))
      (setq reserve (- reserve 2))) ; May be 3 instead of 2 with some toolkits?
    (propertize " "
                'display `((space :align-to (- (+ right right-fringe right-margin)
                                               ,reserve)))
                'face face))

  (defun ml-render-2-part (left right &optional fill-face)
    "Show a modeline with left and right aligned parts."
    (concat left
            (ml-fill-to-right (string-width (format-mode-line right)) fill-face)
            right))

  (setq mode-line-align-right
        '(
          " [" tvd-emacs-version "] "

          ;; added because of eyebrowse
          mode-line-misc-info

          '(:eval (propertize
                   (if (eq defining-kbd-macro t)
                       "[REC]"
                     "")
                   'face 'rec-face))

          mode-line-end-spaces))

  (setq mode-line-align-left
        '(
          "%e"
          mode-line-front-space
          mode-line-mule-info
          mode-line-modified
          mode-line-remote
          "  "
          mode-line-buffer-identification
          "  "
          mode-line-position
          " (%m) "))

  (setq-default mode-line-format
                '((:eval
                   (ml-render-2-part
                    mode-line-align-left
                    mode-line-align-right)))))



(provide 'init-modeline)
;;; init-modeline.el ends here
