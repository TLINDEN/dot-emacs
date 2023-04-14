;; ** .emacs config version

;; My emacs  config has a  version (consisting  of a timestamp  with a
;; serial), which I display in the mode line. So I can clearly see, if
;; I'm using an outdated config somewhere.
(defvar tvd-emacs-version "20230412.01")

;; I prefer a bare bones emacs window without any distractions, so turn them off.
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq use-dialog-box nil)
(scroll-bar-mode 0)

;; needs to be disabled to be able to load it from elpa
(setq tramp-mode nil)

;;; ** stay silent on startup
(setq initial-scratch-message "")
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message "scip")

;; from purcell's config, used below
(defun sanityinc/add-subdirs-to-load-path (parent-dir)
  "Add every non-hidden subdir of PARENT-DIR to `load-path'."
  (let ((default-directory parent-dir))
    (setq load-path
          (append
           (cl-remove-if-not
            #'file-directory-p
            (directory-files (expand-file-name parent-dir) t "^[^\\.]"))
           load-path))))


;;; setup loading of init files, this is our base directory: ~/.emacs-init.d/
(setq tvd-config-dir (expand-file-name "~/.emacs.d"))
(setq user-emacs-directory tvd-config-dir)

;;; ~/.emacs-init.d/init/ contains the rest of the init files
(setq tvd-init-dir (expand-file-name "init" tvd-config-dir))

;;; initialize package manager
(require 'package)

;;; Install into separate package dirs for each Emacs version, to prevent bytecode incompatibility
(setq package-user-dir
      (expand-file-name (format "elpa-%s.%s" emacs-major-version emacs-minor-version)
                        tvd-config-dir))

(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

;; load'em
(sanityinc/add-subdirs-to-load-path package-user-dir)

;;; dont mess around
(setq package-enable-at-startup nil)

;;; setup use-package
(unless (package-installed-p 'use-package)
  ;; (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))



;;; iterate over init dir and load all configs
(defun tvd-load-init-file (f)
  (load-file f))
(mapc 'tvd-load-init-file (directory-files (expand-file-name "init" tvd-config-dir) t ".*el"))


;;; ** Some globals
;; no comment margins
(setq-default comment-column 0)

;; indent defaults, also look for indentation.el
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)




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





;; clean up modeline after loading everyting
(message "")

;; FIXME: modeline emacs version not set and wrong color!


;;; ** END OF MANUAL CONFIG

;; If I  ever use custom-group  to customize a  mode, then I  create a
;; manual config  section for  it using the  values, custom  has added
;; here. So, in normal times this should be empty, but needs to exist.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(tramp dictcc beacon which-key goto-last-change browse-kill-ring fringe-current-line swiper smex undo-tree fic-mode cmake-mode yaml-mode windresize web-mode use-package tablist solarized-theme smartparens rust-mode projectile persistent-scratch org-bullets markdown-mode magit iedit ibuffer-vc ibuffer-tramp hydra htmlize highlight-indentation go-mode eyebrowse elmacro dumb-jump dired-ranger dired-k dired-filter default-text-scale change-inner buffer-move))
 '(safe-local-variable-values '((ruby-indent-level 4))))

;; ** done

;; Finally, this message is being displayed.  If this isn't the case I
;; know easily that something went wrong.

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

