;; *** sgml

;; Used for XML and the likes.

(setq sgml-set-face t)
(setq sgml-balanced-tag-edit t)
(setq sgml-omittag-transparent nil)
(setq sgml-auto-insert-required-elements t)

(setq sgml-markup-faces
      '((start-tag . font-lock-function-name-face)
        (end-tag . font-lock-function-name-face)
        (comment . font-lock-comment-face)
        (pi . font-lock-other-type-face)
        (sgml . font-lock-variable-name-face)
        (doctype . font-lock-type-face)
        (entity . font-lock-string-face)
        (shortref . font-lock-keyword-face)))


(provide 'init-sgml)
;;; init-sgml.el ends here
