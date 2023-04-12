(deftheme tom-past-century
  "tom-past-century")

(custom-theme-set-variables
 'tom-past-century
 '(custom-safe-themes (quote ("203fe0858c2018058526eff9887b06facf5044a94cf8af4dbf66bd16057d28f1" "d88c43fe03ac912e35963695caf0ae54bc6ce6365c3a42da434ef639f7a37399" default)))
 '(package-selected-packages (quote (magit)))
 '(safe-local-variable-values (quote ((ruby-indent-level 4)))))

(custom-theme-set-faces
 'tom-past-century
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :width normal))))
 '(custom-documentation-face ((t (:foreground "Navy"))))
 '(custom-group-tag-face-1 ((((class color) (background light)) (:underline t :foreground "VioletRed"))))
 '(dired-directory ((t (:inherit font-lock-keyword-face))))
 '(eyebrowse-mode-line-active ((t (:foreground "Blue" :background "White" :bold t))))
 '(font-lock-builtin-face ((t (:foreground "BlueViolet"))))
 '(font-lock-comment-face ((t (:foreground "DarkGreen"))))
 '(font-lock-constant-face ((t (:foreground "Magenta"))))
 '(font-lock-doc-face ((t (:foreground "DarkOrange3"))))
 '(font-lock-function-name-face ((t (:bold nil :foreground "DarkOrchid"))))
 '(font-lock-keyword-face ((t (:foreground "Blue"))))
 '(font-lock-string-face ((t (:foreground "Red"))))
 '(font-lock-type-face ((t (:foreground "DarkSlateBlue"))))
 '(font-lock-variable-name-face ((t (:foreground "Sienna"))))
 '(font-lock-warning-face ((t (:bold t :foreground "Red"))))
 '(highlight ((t (:background "DarkSeaGreen1"))))
 '(ido-only-match ((t (:foreground "dark green" :weight bold))))
 '(info-title-1 ((t (:inherit outline-1))))
 '(info-title-2 ((t (:inherit outline-2))))
 '(info-title-3 ((t (:inherit outline-3))))
 '(info-title-4 ((t (:inherit outline-4))))
 '(mmm-default-submode-face ((t nil)))
 '(mode-line ((t (:foreground "White" :background "Blue"))))
 '(mode-line-inactive ((t (:foreground "White" :background "DimGray"))))
 '(org-date ((t (:foreground "dark gray" :underline t))))
 '(org-level-1 ((t (:height 1.18 :foreground "medium slate blue" :underline t))))
 '(org-level-2 ((t (:height 1.16 :foreground "sea green" :underline t :weight normal))))
 '(org-level-3 ((t (:height 1.14 :foreground "saddle brown" :underline t))))
 '(org-level-4 ((t (:height 1.12 :foreground "OrangeRed2" :underline t))))
 '(org-level-5 ((t (:height 1.1 :underline t))))
 `(org-meta-line ((t (:inherit fixed-pitch))))
 `(org-document-info-keyword ((t (:inherit fixed-pitch))))
 `(org-verbatim ((t (:inherit fixed-pitch))))
 `(org-table ((t (:inherit fixed-pitch))))
 `(org-hide ((t (:inherit fixed-pitch))))
 `(org-date ((t (:inherit fixed-pitch :underline nil))))
 `(org-checkbox ((t (:inherit fixed-pitch :weight bold))))
 `(org-done ((t (:inherit fixed-pitch))))
 `(org-todo ((t (:inherit fixed-pitch))))
 `(org-tag ((t (:inherit fixed-pitch))))
 `(org-block-begin-line ((t (:inherit fixed-pitch))))
 `(org-block-end-line ((t (:inherit fixed-pitch))))
 `(org-block ((t (:inherit fixed-pitch))))
 `(org-priority ((t (:inherit fixed-pitch :weight normal))))
 `(org-special-keyword ((t (:inherit fixed-pitch))))
 '(outline-1 ((t (:height 1.2 :inherit font-lock-function-name-face :underline t :weight bold))))
 '(outline-2 ((t (:height 1.15 :inherit font-lock-variable-name-face :underline t :weight bold))))
 '(outline-3 ((t (:height 1.1 :inherit font-lock-keyword-face :underline t :weight bold))))
 '(outline-4 ((t (:height 1.05 :foreground "DodgerBlue3" :underline t))))
 '(region ((t (:foreground "Aquamarine" :background "Darkblue"))))
 '(secondary-selection ((t (:foreground "Green" :background "darkslateblue"))))
 '(which-key-key-face ((t (:weight bold)))))

(provide-theme 'tom-past-century)