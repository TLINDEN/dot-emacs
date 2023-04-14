;;; Backup Config

;; I save backup files in a  central location below the init dir, that
;; way they don't clutter productive file systems or repos.

(setq tvd-backup-directory (expand-file-name "backups" tvd-config-dir))
(if (not (file-exists-p tvd-backup-directory))
    (make-directory tvd-backup-directory t))

;; there's even a trash
(setq tvd-trash-directory (expand-file-name "trash" tvd-backup-directory))


;; actual configuration of all things backup related:
(setq make-backup-files t               ; backup of a file the first time it is saved.
      backup-by-copying t               ; don't clobber symlinks
      version-control t                 ; version numbers for backup files
      delete-old-versions t             ; delete excess backup files silently
      delete-by-moving-to-trash t
      kept-old-versions 6               ; oldest versions to keep when a new numbered backup is made (default: 2)
      kept-new-versions 9               ; newest versions to keep when a new numbered backup is made (default: 2)
      auto-save-default t               ; auto-save every buffer that visits a file
      auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 200            ; number of keystrokes between auto-saves (default: 300)
      delete-by-moving-to-trash t
      trash-directory tvd-trash-directory
      backup-directory-alist `(("emacs.d/\\(recentf\\|ido.last\\|places\\)" . nil) ; do not backup state files
                               ("." . ,tvd-backup-directory))) ; backup everything else

;; However, if the file to be backed up is remote, backup
;; per remote directory. that way, no root owned files end
;; up in my home directory, ready to be read by everyone.
;; This is system specific and only matches special host names.
;; FIXME: find out programatically hostname und remote user to make this generic
(advice-add 'make-backup-file-name-1 :before
            '(lambda (&rest file)
               (let ((filename (car file)))
                 (if (string-match "\\(/ssh:.devel[0-9]+\\):/" filename)
                     (setq backup-directory-alist `(("." . ,(concat (match-string 1 filename) ":/root/.emacs.d/backups"))))
                   (setq backup-directory-alist `(("." . ,tvd-backup-directory)))))))

;; FIXME: and/or check [[https://www.gnu.org/software/tramp/#Auto_002dsave-and-Backup][gnu.org]]
;; + tramp-default-proxies-alist



;;; console backspace fix

;; make backspace work in console sessions
(define-key key-translation-map [?\C-h] [?\C-?])


;;; ** y means yes
;; y is shorter than yes and less error prone.
(defalias 'yes-or-no-p 'y-or-n-p)


;;; ** show col in modeline
;; very useful to know current column
(column-number-mode t)

;;; ** file or buffer in title
;; this can be seen in xmobar
(setq frame-title-format '(buffer-file-name "emacs %f" ("emacs %b")))


;;; ** avoid invalid files
(setq require-final-newline t)


;;; ** byte-compile all of them, if needed
;; ;; handy function to recompile all lisp files
;; (defun recompile-el()
;;   (interactive)
;;   (byte-recompile-directory tvd-config-dir 0))


;;; ** re-read a modified buffer

;; F5 == reload file if it has been modified by another process, shift
;; because Xmonad
(global-set-key (kbd "S-<f5>")                                                            ; re-read a buffer from disk (revert)
                (lambda (&optional force-reverting)
                  "Interactive call to revert-buffer. Ignoring the auto-save
 file and not requesting for confirmation. When the current buffer
 is modified, the command refuses to revert it, unless you specify
 the optional argument: force-reverting to true."
                  (interactive "P")
                  ;;(message "force-reverting value is %s" force-reverting)
                  (if (or force-reverting (not (buffer-modified-p)))
                      (revert-buffer :ignore-auto :noconfirm)
                    (error "The buffer has been modified"))))



;;; ** handy aliases

;; M-x q r <ret> is short enough  for me, no need for key bindings for
;; those

(defalias 'qrr       'query-replace-regexp)
(defalias 'qr        'query-replace)
(defalias 'cr        'comment-region)
(defalias 'ur        'uncomment-region)
(defalias 'ir        'indent-region)
(defalias 'dv        'describe-variable)
(defalias 'dk        'describe-key)
(defalias 'df        'describe-function)
(defalias 'dp        'describe-char)
(defalias 'dm        'describe-mode)
(defalias 'db        'describe-bindings)
(defalias 'dl        'finder-commentary) ; aka "describe library"
(defalias 'repl      'ielm)
(defalias 'ws        'window-configuration-to-register) ; save window config
(defalias 'wr        'jump-to-register)                 ; restore window config
(defalias 'rec       'rectangle-mark-mode)
(defalias '|         'shell-command-on-region) ; apply shell command on region


;;; ** various settings

;; point stays while scrolling
(setq scroll-preserve-screen-position t)

;; do not save until I hit C-x-s
(setq auto-save-default nil)

;; show all buffers in buffer menu
(setq buffers-menu-max-size nil)

;; start to wrap at 30 entries
(setq mouse-buffer-menu-mode-mult 30)

;; I'm grown up!
(setq disabled-command-function nil)


;;; ** copy/paste Config

;; Related:
;; - see also mark-copy-yank-things-mode below!
;; - see also: move-region below (for M-<up|down>)
;; - see also: expand-region below (for C-0)

;; middle mouse button paste at click not where cursor is
(setq mouse-yank-at-point t)

;; highlight selected stuff (also allows DEL of active region)
(setq transient-mark-mode t)

;; pasting onto selection deletes it
(delete-selection-mode t)

;; delete whole lines
(setq kill-whole-line t)

;; middle-mouse, shift-INSERT use both X-selection and Emacs-clipboard
(setq x-select-enable-primary t)
(setq x-select-enable-clipboard nil)
(setq select-enable-primary t) ;; c-y use primary

;; marked region automatically copied, also on win
(setq mouse-drag-copy-region t)


;;; ** use more mem
(setq gc-cons-threshold 20000000)


;;; ** better file name completion

;; Complete filenames case insensitive and ignore certain files during completion.
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)

;; via [[http://endlessparentheses.com/improving-emacs-file-name-completion.html][endlessparantheses]]
(mapc (lambda (x)
        (add-to-list 'completion-ignored-extensions x))
      '(".aux" ".bbl" ".blg" ".exe"
        ".log" ".meta" ".out" ".pdf"
        ".synctex.gz" ".tdo" ".toc"
        "-pkg.el" "-autoloads.el" ".elc"
        ".dump" ".ps" ".png" ".jpg"
        ".gz" ".tgz" ".zip"
        "Notes.bib" "auto/"))


;;; ** abbreviations

;; Do I really need those anymore? Added ca 1999...

(define-abbrev-table 'global-abbrev-table '(
                                            ("oe" "&ouml;" nil 0)
                                            ("ue" "&uuml;" nil 0)
                                            ("ae" "&auml;" nil 0)
                                            ("Oe" "&Ouml;" nil 0)
                                            ("Ue" "&Uuml;" nil 0)
                                            ("Ae" "&Auml;" nil 0)
                                            ("<li>" "<li> </li>" nil 0)
                                            ("<ul>" "<ul> </ul>" nil 0)
                                            ))

;; do NOT ask to save abbrevs on exit
(setq save-abbrevs nil)


;;; ** meaningful names for buffers with the same name

;; from ([[https://github.com/bbatsov/prelude][prelude]])

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers


;;; ** My own global variables

;; narrowed fringe background
(defvar tvd-fringe-narrow-bg "OrangeRed")


;;; ** Recenter config

;; [[http://oremacs.com/2015/03/28/recenter/][via abo abo]]

;; However, I set the first position  to 1, which causes the window to
;; be recentered on the second line, that is, I can see one line above
;; the current one. It works the same with bottom, which I intend, but
;; I think this is a recenter calculation bug.

(setq recenter-positions '(1 middle bottom))

;; On my new linux system running kubuntu I am unable to insert ^ ` or ~.
;; see: https://unix.stackexchange.com/questions/28170/some-keys-are-invalid-on-emacs-when-using-german-keyboard
(require 'iso-transl)
