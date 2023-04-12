;; *** eShell stuff, or if interactive stuff is needed, use ansi-term

;; I am  a hardcore bash  user, but from time  to time eshell  is good
;; enough. It's great when used remote when only sftp is supported.

(require 'eshell)

;; fac'ifier
(defmacro with-face (str &rest properties)
  `(propertize ,str 'face (list ,@properties)))

;; custom prompt, which resembles my bash prompt
(defun shk-eshell-prompt ()
  (let ((header-bg "Azure"))
    (concat
     (with-face "\n")
     (with-face (format-time-string
                 "[%Y-%m-%d %H:%M] --- ["
                 (current-time)) :background header-bg :foreground "Black")
     (with-face (concat (eshell/pwd) "") :background header-bg :foreground "Blue")
     (with-face "] --- " :background header-bg :foreground "Black")
     (with-face  (or
                  (ignore-errors (format "(%s)" (vc-responsible-backend default-directory)))
                  "") :background header-bg)
     (with-face "\n" :background header-bg)
     (with-face user-login-name :foreground "blue")
     "@"
     (with-face "localhost" :foreground "blue")
     (if (= (user-uid) 0)
         (with-face " #" :foreground "red")
       " $")
     " ")))

(setq eshell-prompt-function 'shk-eshell-prompt)
(setq eshell-highlight-prompt nil)

;; I use my own virtual loggin target /dev/log, just redirect
;; command output to /dev/log and it will be saved to
;; the *LOG* buffer. > inserts, >> appends
;; N.B: /dev/kill puts the stuff into the kill-ring.
(defun log-comment ()
  (with-current-buffer (get-buffer-create "*LOG*")
    (insert (format "# %s\n" (time-stamp-string)))))

(defun log-insert (string)
  (with-current-buffer (get-buffer-create "*LOG*")
    (delete-region (point-min) (point-max))
    (log-comment)
    (insert string)
    (message "wrote output to *LOG* buffer")))

(defun log-append (string)
  (with-current-buffer (get-buffer-create "*LOG*")
    (end-of-buffer)
    (newline)
    (log-comment)
    (insert string)
    (message "wrote output to *LOG* buffer")))

;; must return a defun which gets the stuff as ARG1
;; 'mode is 'overwrite or 'append
(add-to-list 'eshell-virtual-targets '("/dev/log" (lambda (mode)
                                              (if (eq mode 'overwrite)
                                                  'log-insert
                                                'log-append))
                                      t
                                      ))

;; eshell config
(eval-after-load "eshell"
  '(progn
     (add-hook 'eshell-mode-hook
               (lambda ()
                 (local-unset-key (kbd "C-c C-r")) ; we're already using this for windresize
                 (add-to-list 'eshell-visual-commands "tail")
                 (add-to-list 'eshell-visual-commands "top")
                 (add-to-list 'eshell-visual-commands "vi")
                 (add-to-list 'eshell-visual-commands "ssh")
                 (add-to-list 'eshell-visual-commands "tail")
                 (add-to-list 'eshell-visual-commands "mutt")
                 (add-to-list 'eshell-visual-commands "note")
                 (setenv "TERM" "xterm")
                 (local-set-key (kbd "C-l") 'eshell/clear)
                 (define-key viking-mode-map (kbd "C-d") nil) ;; need to undef C-d first
                 (local-set-key (kbd "C-d") 'eshell/x)
                 (setq mode-name "ESH"
                       eshell-hist-ignoredups t
                       eshell-history-size 5000
                       eshell-where-to-jump 'begin
                       eshell-review-quick-commands nil
                       eshell-smart-space-goes-to-end t
                       eshell-scroll-to-bottom-on-input 'all
                       eshell-error-if-no-glob t
                       eshell-save-history-on-exit t
                       eshell-prefer-lisp-functions t)))))

;; exit and restore viking key binding afterwards
(defun eshell/x (&rest args)
  (interactive)
  (eshell-life-is-too-much)
  (define-key viking-mode-map (kbd "C-d") 'viking-kill-thing-at-point))

;; open files in emacs, split the shell if not already splitted
;; open empty window if no file argument given.
(defun eshell/emacs (&rest args)
  "Editor commands fired from eshell will be handled by emacs, which already runs anyway."
  (interactive)
  (let* ((framesize (frame-width))
         (winsize (window-body-width)))
    (progn
      (if (eq winsize framesize)
          (split-window-horizontally))
      (other-window 1)
      (if (null args)
          (bury-buffer)
        (mapc #'find-file (mapcar #'expand-file-name (eshell-flatten-list (reverse args))))))))

(defun eshell/clear ()
  "Better clear  command than (recenter  0) which doesn't work  as I
want.  This version really removes  the output of previous commands
and puts the shell to the beginning of a really (then) empty eshell
buffer. However,  just to be sure  that I do no  accidentally clear
some  shell output  that might  be useful  in the  future, it  also
copies   the   cleared   stuff   into   a   backup   buffer   named
*eshell-log-buffer*, just in case."
  (interactive)
  (let ((beg (point-min))
        (end (point-max))
        (savebuffer "*eshell-log-buffer*")
        (log (buffer-substring-no-properties (point-min) (point-max))))
    (progn
      (if (not (get-buffer savebuffer))
          (get-buffer-create savebuffer))
      (with-current-buffer savebuffer
        (goto-char (point-max))
        (insert log))
      (delete-region beg end)
      (eshell-emit-prompt))))

(defun eshell/perldoc (&rest args)
  "Like `eshell/man', but invoke `perldoc'."
  (funcall 'eshell/perldoc (apply 'eshell-flatten-and-stringify args)))

(defun eshell/perldoc (man-args)
  (interactive "sPerldoc: ")
  (require 'man)
  (let ((manual-program "perldoc"))
    (man man-args)))

(defun eshell-here ()
  "Opens up a new shell in the directory associated with the
current buffer's file. The eshell is renamed to match that
directory to make multiple eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (height (/ (window-total-height) 3))
         (name   (car (last (split-string parent "/" t)))))
    (split-window-vertically (- height))
    (other-window 1)
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))
    (insert (concat "ls"))
    (eshell-send-input)))

;; via howardism
(defun eshell-there (host)
  "Opens a shell on a remote host using tramp."
  (interactive "sHost: ")
  (let ((default-directory (format "/%s:" host)))
    (eshell host)))

(defalias 'es        'eshell-here)
(defalias 'et        'eshell-there)
(defalias 'eshell/vi 'eshell/emacs)

;; plan9 smart command, edit while exec if not silent or successful
(require 'em-smart)

;; eshell shell aliases. I set the global
;; defvar here so there's no need to transport
;; ~/.emacs.d/eshell/aliases across networks
(setq eshell-command-aliases-list ())

(defun +alias (al cmd)
  "handy wrapper function to convert alias symbols
to alias strings to avoid writing 4 quotes per alias.
AL is a single-word symbol naming the alias, CMD is
a list symbol describing the command."
  (add-to-list 'eshell-command-aliases-list
               (list (symbol-name al)
                     (mapconcat 'symbol-name cmd " "))))

;; actual aliases
(+alias 'l      '(ls -laF $*))
(+alias 'll     '(ls -l $*))
(+alias 'la     '(ls -a $*))
(+alias 'lt     '(ls -ltr $*))
(+alias '..     '(cd ..))
(+alias '...    '(cd ../..))
(+alias '....   '(cd ../../..))
(+alias '.....  '(cd ../../../..))
(+alias 'md     '(mkdir -p $*))
(+alias 'emacs  '(find-file $1))
(+alias 'less   '(find-file-read-only $1))
(+alias 'x      '(eshell/exit))

;; no need for less or more, this is emacs, isn't it?
(setenv "PAGER" "cat")
