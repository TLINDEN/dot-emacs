;; *** Dired

;; I use dired  for two things: from inside magit  as a convenient way
;; to add or remove files from a  repository. Or if I want to rename a
;; bunch of files using search/replace and other editing commands.

;; But as with everything else I use,  it must fit and so I managed to
;; tune this as well.

;; [[http://ergoemacs.org/emacs/emacs_dired_tips.html][More Hints]]

;; **** dired-k

;; dired-k is k  for dired/emacs: it colorizes files  and directory by
;; age, that is, the older the  greyer they get. And it displays flags
;; about the git status of each file, which is really handy.

;; However,  it only  works with  git installed  and if  enabled stops
;; dired to work  completely. So I define an exception  here and don't
;; load k if there's no git (e.g. on my notebook at work)
(when (string-match "version" (shell-command-to-string "git version"))
  (use-package dired-k
               :init
               (add-hook 'dired-initial-position-hook 'dired-k)
               (add-hook 'dired-after-readin-hook #'dired-k-no-revert)

               :config
               (setq dired-k-padding 2)))

;; **** dired-hacks

;; [[https://github.com/Fuco1/dired-hacks][Fuco1s dired-hacks]] is a
;; place to find the really cool stuff, I mostly use the filters.
(use-package dired-filter
             :config

             (defun tvd-dired-quit-or-filter-pop (&optional arg)
               "Remove a filter from the filter stack. If none left, quit the dired buffer."
               (interactive "p")
               (if dired-filter-stack
                   (dired-filter-pop arg)
                 (quit-window))))

(use-package dired-ranger)

;; **** dired sort helpers

;; This sort function by [[http://ergoemacs.org/emacs/dired_sort.html][Xah Lee]]
;; is easy to use and does what it should, great!, However, I added some -desc
;; sister sorts for reverse sorting.
(defun xah-dired-sort ()
  "Sort dired dir listing in different ways.
Prompt for a choice.
URL `http://ergoemacs.org/emacs/dired_sort.html'
Version 2015-07-30"
  (interactive)
  (let (sort-by arg)
    (setq sort-by (ido-completing-read "Sort by:" '( "date" "size" "name" "dir" "date-desc" "size-desc" "name-desc" "dir-desc" )))
    (cond
     ((equal sort-by "name") (setq arg "-Al --si --time-style long-iso "))
     ((equal sort-by "date") (setq arg "-Al --si --time-style long-iso -t"))
     ((equal sort-by "size") (setq arg "-Al --si --time-style long-iso -S"))
     ((equal sort-by "dir") (setq arg "-Al --si --time-style long-iso --group-directories-first"))
     ((equal sort-by "name-desc") (setq arg "-Al --si --time-style long-iso -r"))
     ((equal sort-by "date-desc") (setq arg "-Al --si --time-style long-iso -t -r"))
     ((equal sort-by "size-desc") (setq arg "-Al --si --time-style long-iso -S -r"))
     ((equal sort-by "dir-desc") (setq arg "-Al --si --time-style long-iso --group-directories-first -r"))
     (t (error "logic error 09535" )))
    (dired-sort-other arg )))

;; **** dired git helpers

;; [[http://blog.binchen.org/posts/the-most-efficient-way-to-git-add-file-in-dired-mode-emacsendiredgit.html][via bin chen]]:
;; make git commands available from dired  buffer, which can be used in
;; those rare cases, where my wrappers below don't fit.
(defun diredext-exec-git-command-in-shell (command &optional arg file-list)
  "Run a shell command git COMMAND  ' on the marked files.  if no
files marked, always operate on current line in dired-mode"
  (interactive
   (let ((files (dired-get-marked-files t current-prefix-arg)))
     (list
      ;; Want to give feedback whether this file or marked files are used:
      (dired-read-shell-command "git command on %s: " current-prefix-arg files)
      current-prefix-arg
      files)))
  (unless (string-match "[?][ \t]\'" command)
    (setq command (concat command " *")))
  (setq command (concat "git " command))
  (dired-do-shell-command command arg file-list)
  (message command))

;; some git  commandline wrappers  which directly  work on  git files,
;; called with "hydras".
(defun tvd-dired-git-add(&optional arg file-list)
  "Add marked or current file to current repository (stash)."
  (interactive
    (let ((files (dired-get-marked-files t current-prefix-arg)))
      (list current-prefix-arg files)))
  (dired-do-shell-command "git add -v * " arg file-list)
  (revert-buffer))

(defun tvd-dired-git-rm(&optional arg file-list)
  "Remove marked or current file from current repository and filesystem."
  (interactive
   (let ((files (dired-get-marked-files t current-prefix-arg)))
     (list current-prefix-arg files)))
  (dired-do-shell-command "git rm -rf * " arg file-list)
  (revert-buffer))

(defun tvd-dired-git-ungit(&optional arg file-list)
  "Like `tvd-dired-git-rm' but keep the files in the filesystem (unstage)."
  (interactive
   (let ((files (dired-get-marked-files t current-prefix-arg)))
     (list current-prefix-arg files)))
  (dired-do-shell-command "git rm -rf --cached * " arg file-list)
  (revert-buffer))

;; **** dired navigation

;; I'm used to jump around with pos1+end
(defun tvd-dired-begin ()
  "Move point to the first directory in the listing .."
  (interactive)
  (goto-char (point-min))
  (dired-next-dirline 2))

(defun tvd-dired-end ()
  "Move point to the last file or directory in the listing."
  (interactive)
  (goto-char (point-max))
  (dired-previous-line 1))

;; **** dired buffer names

;; This took  me a long time  to figure out,  but I finally got  it: I
;; really  hate it  how  dired names  its buffers,  it  just uses  the
;; basename part of  the current working directory as  buffer name. So
;; when there are  a couple of dozen  buffers open and one  of them is
;; named "tmp"  I just can't see  it. So what  I do here is  to rename
;; each   dired  buffer   right   after  its   creation  by   advising
;; `dired-internal-noselect'. My  dired buffers  have such  names now:
;; *dired: ~/tmp*. I  can find them easily, and I  can reach all dired
;; buffers very  fast thanks to  the *dired  prefix. And they  are now
;; clearly  marked  as  non-file  buffers. In  fact  I  consider  this
;; behavior as a bug, but I doubt many people would agree :)

(advice-add 'dired-internal-noselect
            :filter-return
            '(lambda (buffer)
               "Modify dired buffer names to this pattern: *dired: full-path*"
               (interactive)
               (with-current-buffer buffer
                 (rename-buffer (format "*dired: %s*" default-directory)))
               buffer))

;; **** dired config and key bindings

;; and finally put everything together.

(eval-after-load 'dired
  '(progn
     ;; dired vars
     (setq dired-listing-switches "-lt")

     ;; stay  with 1  dired buffer  per instance
     ;; when changing directories
     (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
     (define-key dired-mode-map (kbd "<C-right>") 'dired-find-alternate-file)
     (define-key dired-mode-map (kbd "^") (lambda () (interactive) (find-alternate-file "..")))
     (define-key dired-mode-map (kbd "<C-left>") (lambda () (interactive) (find-alternate-file "..")))

     ;; Xah Lee'S custom sort's
     (define-key dired-mode-map (kbd "s") 'xah-dired-sort)

     ;; my git "hydras"
     (define-prefix-command 'tvd-dired-git-map)
     (define-key dired-mode-map (kbd "g") 'tvd-dired-git-map)
     (define-key tvd-dired-git-map (kbd "a") 'tvd-dired-git-add)
     (define-key tvd-dired-git-map (kbd "d") 'tvd-dired-git-rm)
     (define-key tvd-dired-git-map (kbd "u") 'tvd-dired-git-ungit)

     ;; edit filenames
     (defalias 'edit-dired 'wdired-change-to-wdired-mode)
     (define-key dired-mode-map (kbd "C-c C-c") 'wdired-change-to-wdired-mode)

     ;; dired-hacks filters
     (define-key dired-mode-map (kbd "f") dired-filter-map)
     (define-key dired-mode-map (kbd "q") 'tvd-dired-quit-or-filter-pop)
     (define-key dired-mode-map (kbd "Q") 'dired-filter-pop-all)

     ;; ranger, multi file copy/move
     (define-prefix-command 'tvd-dired-ranger-map)
     (define-key dired-mode-map (kbd "r") 'tvd-dired-ranger-map)
     (define-key tvd-dired-ranger-map (kbd "c") 'dired-ranger-copy)
     (define-key tvd-dired-ranger-map (kbd "p") 'dired-ranger-paste)
     (define-key tvd-dired-ranger-map (kbd "m") 'dired-ranger-move)

     ;; navigation,  use TAB  and C-TAB  to move
     ;; point to  next or prev dir  like in info
     ;; mode, and  HOME+END to reach the  end or
     ;; beginning of the listing.
     (define-key dired-mode-map (kbd "<tab>") 'dired-next-dirline)
     (define-key dired-mode-map (kbd "<C-tab>") 'dired-prev-dirline)
     (define-key dired-mode-map (kbd "<home>") 'tvd-dired-begin)
     (define-key dired-mode-map (kbd "<end>") 'tvd-dired-end)

     ;; overwrite some defaults I do not use anyway
     (define-key dired-mode-map (kbd "n") 'dired-create-directory)
     ))
;; **** Dired Hydra

;; FIXME: not yet customized to fit my own config
(when (fboundp 'defhydra)
  (defhydra hydra-dired (:hint nil :color pink)
    "
_+_ mkdir          _v_iew           _m_ark             _(_ details        _i_nsert-subdir    _W_dired (EDIT FILENAMES)
_C_opy             _O_ view other   _U_nmark all       _)_ omit-mode      _$_ hide-subdir    C-c C-c : edit
_D_elete           _o_pen other     _u_nmark           _l_ redisplay      _w_ kill-subdir
_R_ename           _M_ chmod        _t_oggle           _g_ revert buf     _e_ ediff          _q_uit
_Y_ rel symlink    _G_ chgrp        _E_xtension mark   _s_ort             _=_ pdiff
_S_ymlink          ^ ^              _F_ind marked      _._ toggle hydra   \\ flyspell
_r_sync            ^ ^              ^ ^                ^ ^                _?_ summary
_z_ compress-file  _A_ find regexp   / Filter
_Z_ compress       _Q_ repl regexp

T - tag prefix

"
    ("\\" dired-do-ispell nil)
    ("(" dired-hide-details-mode nil)
    (")" dired-omit-mode nil)
    ("+" dired-create-directory nil)
    ("=" diredp-ediff nil)         ;; smart diff
    ("?" dired-summary nil)
    ("$" diredp-hide-subdir-nomove nil)
    ("A" dired-do-find-regexp nil)
    ("C" dired-do-copy nil)        ;; Copy all marked files
    ("D" dired-do-delete nil)
    ("E" dired-mark-extension nil)
    ("e" dired-ediff-files nil)
    ("F" dired-do-find-marked-files nil)
    ("G" dired-do-chgrp nil)
    ("g" revert-buffer nil)        ;; read all directories again (refresh nil)
    ("i" dired-maybe-insert-subdir nil)
    ("l" dired-do-redisplay nil)   ;; relist the marked or singel directory
    ("M" dired-do-chmod nil)
    ("m" dired-mark nil)
    ("O" dired-display-file nil)
    ("o" dired-find-file-other-window nil)
    ("Q" dired-do-find-regexp-and-replace nil)
    ("R" dired-do-rename nil)
    ("r" dired-do-rsynch nil)
    ("S" dired-do-symlink nil)
    ("s" dired-sort-toggle-or-edit nil)
    ("t" dired-toggle-marks nil)
    ("U" dired-unmark-all-marks nil)
    ("u" dired-unmark nil)
    ("v" dired-view-file nil)      ;; q to exit, s to search, = gets line #
    ("w" dired-kill-subdir nil)
    ("W" wdired-change-to-wdired-mode nil)
    ("Y" dired-do-relsymlink nil)
    ("z" diredp-compress-this-file nil)
    ("Z" dired-do-compress nil)
    ("q" nil nil)
    ("." nil nil :color blue))

  (define-key dired-mode-map "?" 'hydra-dired/body))
