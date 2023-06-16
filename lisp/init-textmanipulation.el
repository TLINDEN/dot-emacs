;; ** Text Manupilation
;; *** expand-region

;; One of the  best modes I ever discovered. Press  C-= multiple times
;; to create a larger and larger region. I use C-0 (zero) because on a
;; german keyboard this is the same as C-= without pressing shift.

(use-package expand-region
             :config
             (global-set-key (kbd "C-0") 'er/expand-region)) ; C-= without pressing shift on DE keyboard

;; related to ER:
;; *** Mark, Copy, Yank Things

;; For a long time this stuff was  located here in my emacs config. As
;; it grew larger  and larger I decided  to put it into  its own mode:
;; mark-copy-yank-things-mode,  which can  be  found  on github  these
;; days.

;; With this,  you can quickly mark  or copy or copy+yank  things like
;; words, ip's,  url's, lines or defun's  with one key binding.  I use
;; this permanently and couldn't live without it anymore.

;; A special feature is the copy+yanking, this is something vi offers:
;; go to a line, press yy, then  p and the current line will be yanked
;; below.  Prefix  with a  number and copy+yank  more lines.   This is
;; really cool and (in  vi) often used. So, with this  mode, I can use
;; it with  emacs as well. For  example, say you edit  a configuration
;; file  and added  a  complicated  statement. Next  you  need to  add
;; another very similar  statement. Instead of entering  it again, you
;; just  hit  <C-c  y y>  and  the  current  line  appears as  a  copy
;; below. Change the differences and you're done!

(use-package mark-copy-yank-things-mode
             :ensure nil ;; instaled by el-get
             :config
             (mark-copy-yank-things-global-mode)

             ;; The mode  has a rather  impractical prefix since it's  published on
             ;; github and therefore must be written  in a way not to disturb other
             ;; modes. However, I myself need those simple prefixes:
             (define-key mark-copy-yank-things-mode-map (kbd "C-c")   'mcyt-copy-map)
             (define-key mark-copy-yank-things-mode-map (kbd "M-a")   'mcyt-mark-map)
             ;; I use the default yank map

             ;; With this I  put the last thing  copied into a register  'c.  I can
             ;; then  later  yank  this  using C-v  anytime  without  browsing  the
             ;; kill-ring if I kill things between yanking.  So, C-v always inserts
             ;; the last copied thing, while C-y yanks the last thing killed, which
             ;; might be something else.
             (advice-add 'mcyt--copy-thing
                         :after
                         '(lambda (&rest args)
                            (with-temp-buffer
                              (yank)
                              (copy-to-register 'c (point-min) (point-max)))))

             (defun tvd-insert-c-register ()
               "Paste from the global yank register, fed by mcyt-copy-*"
               (interactive)
               (insert-register 'c))

             (global-set-key (kbd "C-v")             'tvd-insert-c-register)

             ;; copy  a real  number  and  convert it  to  german punctuation  upon
             ;; yanking, so  I can  do some calculations  in 'calculator,  copy the
             ;; result NNN.NN and  paste it into my online  banking formular, where
             ;; it appears as NNN,NN.
             (defun tvd-mcyt-copy-euro (&optional arg)
               "Copy  euro  at point  into  kill-ring  and convert  to  german punctuation"
               (interactive "P")
               (mcyt--blink-and-copy-thing 'mcyt-beginning-of-ip 'mcyt-end-of-ip arg)
               (with-temp-buffer
                 (yank)
                 (beginning-of-buffer)
                 (while (re-search-forward "\\." nil t)
                   (replace-match ","))
                 (kill-region (point-min) (point-max))))

             (define-key mcyt-copy-map (kbd "g") 'tvd-mcyt-copy-euro))


;; --------------------------------------------------------------------------------

;; *** change-inner

;; I use change-inner with a prefix key and some wrappers around
;; mark-copy-yank-things-mode, which is related to change-inner
;; and expand-region.

;; first some functions:
(defun tvd-ci (beg end &optional ins)
  "change-inner simulator which works with symbols instead of strings.

BEG and END must be executable elisp symbols moving (point). Everything
in between will be killed. If INS is non-nil, it will be inserted then."
  (interactive)
  (let ((B nil))
    (funcall beg)
    (setq B (point))
    (funcall end)
    (kill-region B (point))
    (when ins
      (insert ins))))

;; define some custom change-inner's based on mcyt mode
(when (fboundp 'mcyt-beginning-of-comment-block)
  (defun tvd-ci-comment ()
    "\"change inner\" a whole comment [block]."
    (interactive)
    (tvd-ci 'mcyt-beginning-of-comment-block
            'mcyt-end-of-comment-block
            (format "%s;# " comment-start)))

  (defun tvd-ci-quote ()
    "\"change inner\" quoted text."
    (interactive)
    (tvd-ci 'mcyt-beginning-of-quote
            'mcyt-end-of-quote))

  (defun tvd-ci-word ()
    "\"change inner\" a word (like cw in vi)."
    (interactive)
    (tvd-ci 'mcyt-beginning-of-symbol
            'mcyt-end-of-symbol)))

;; some more
(defun tvd-ci-line ()
  "\"change inner\" a whole line."
  (interactive)
  (tvd-ci 'beginning-of-line
          'end-of-line))

(defun tvd-ci-paragraph ()
  "\"change inner\" a whole paragraph."
  (interactive)
  (tvd-ci 'backward-paragraph
          'forward-paragraph))

(defun tvd-ci-buffer ()
  "\"change inner\" a whole buffer."
  (interactive)
  (tvd-ci 'point-min
          'point-max))

(defun tvd-ci-sexp ()
  "\"change inner\" a whole sexp."
  (interactive)
  (er/mark-inside-pairs)
  (call-interactively 'kill-region))

;; [[https://github.com/magnars/change-inner.el][github source]]:
(use-package change-inner
             :config

             ;; Define ALT_R (AltGR) + i as my prefix command for change-inner stuff.
             ;; Since I use a german keyboard, this translates to →.
             ;; I'll refrence it here now as <A-i ...>
             (define-prefix-command 'ci-map)
             (global-set-key (kbd "→") 'ci-map)

             ;; typing the prefix key twice calls the real change-inner
             (define-key ci-map (kbd "→") 'change-inner) ;; <A-i A-i>

             (when (fboundp 'mcyt-beginning-of-comment-block)
               (define-key ci-map (kbd "c") 'tvd-ci-comment) ;; <A-i c>
               (define-key ci-map (kbd "¢") 'tvd-ci-comment) ;; <A-i A-c>

               (define-key ci-map (kbd "q") 'tvd-ci-quote) ;; <A-i q>
               (define-key ci-map (kbd "@") 'tvd-ci-quote) ;; <A-i A-q>

               (define-key ci-map (kbd "w") 'tvd-ci-word) ;; <A-i w>
               (define-key ci-map (kbd "ł") 'tvd-ci-word)) ;; <A-i A-w>

             (define-key ci-map (kbd "l") 'tvd-ci-line) ;; <A-i l>

             (define-key ci-map (kbd "s") 'tvd-ci-sexp) ;; <A-i s>
             (define-key ci-map (kbd "ſ") 'tvd-ci-sexp) ;; <A-i A-s>

             (define-key ci-map (kbd "p") 'tvd-ci-paragraph) ;; <A-i p>
             (define-key ci-map (kbd "þ") 'tvd-ci-paragraph) ;; <A-i A-p>

             (define-key ci-map (kbd "a") 'tvd-ci-buffer) ;; <A-i a>
             (define-key ci-map (kbd "æ") 'tvd-ci-buffer)) ;; <A-i A-a>

;; --------------------------------------------------------------------------------
;; *** Rotate text

;; This one is great as well, I  use it to toggle flags and such stuff
;; in configs or code with just one key binding.

;; Source: [[http://nschum.de/src/emacs/rotate-text/][nschum.de]]

;; (autoload 'rotate-text "rotate-text" nil t)
;; (autoload 'rotate-text-backward "rotate-text" nil t)

(use-package rotate-text
             :ensure nil ;; installed by el-get
             :config

             ;; my toggle list
             (setq rotate-text-words '(("width" "height")
                                       ("left" "right" "top" "bottom")
                                       ("ja" "nein")
                                       ("off" "on")
                                       ("true" "false")
                                       ("nil" "t")
                                       ("yes" "no")))

             ;; C-t normally used by transpose-chars, so, unbind it first
             (global-unset-key (kbd "C-t"))

             ;; however, we cannot  re-bind it globally since then it  could not be
             ;; used in org-mode for org-todo (see below) FIXME: I only use the "t"
             ;; short command anymore, so C-t would be free now, wouldn't it?
             (add-something-to-mode-hooks
              '(c c++ cperl vala web emacs-lisp python ruby yaml go)
              '(lambda ()
                 (local-set-key (kbd "C-t") 'rotate-text))))

;; --------------------------------------------------------------------------------

;; *** Word wrapping
;; same as word-wrap but without the fringe which I hate the most!
(add-something-to-mode-hooks '(tex text eww) 'visual-line-mode)

;; however, it's required when coding, so enable it globally
;; overwritten by visual-line-mode above for specifics
(setq word-wrap t)
;; --------------------------------------------------------------------------------

;; *** Viking Mode

;; Delete  stuff fast.  Press the  key  multiple times  - delete  more
;; things. Inspired by expand-region. Written by myself.

(use-package viking-mode
             :ensure nil ;; installed by el-get
             :config
             (viking-global-mode)
             (setq viking-greedy-kill nil)
             (define-key viking-mode-map (kbd "M-d") 'viking-repeat-last-kill))
;; --------------------------------------------------------------------------------

;; *** HTMLize

;; extracted  from  debian package  emacs-goodies-el-35.2+nmu1,  since
;; there's no other source left. Generates a fontified html version of
;; the current buffer, however it looks.

(use-package htmlize
             :config
             (setq htmlize-output-type "inline-css"))


;; *** iEdit (inline edit multiple searches)

;; Edit all occurences of something at once. Great for re-factoring.

;; (global-set-key (kbd "C-c C-e")           'iedit-mode)
(setq tvd-buffer-undo-list nil)

(use-package iedit
             :config

             ;; Keep buffer-undo-list as is while iedit is active, that is, as long
             ;; as I am  inside iedit I can undo/redo  current occurences. However,
             ;; if I leave iedit and issue  the undo command, ALL changes made with
             ;; iedit  are undone,  whereas the  default behaviour  would be  to go
             ;; through every change made iside iedit, which I hate.

             ;; iedit doesn't  provide a customizable  flag to configure  it's undo
             ;; behavior, so, I modify it myself using defadvice.

             (advice-add 'iedit-mode :before '(lambda (&rest args) ;; save current
                                                (setq tvd-buffer-undo-list buffer-undo-list)))

             (advice-add 'iedit-mode :after '(lambda (&rest args)  ;; restore previously saved
                                               (setq buffer-undo-list tvd-buffer-undo-list))))

(add-hook 'text-mode-hook
          (lambda () (electric-indent-local-mode -1)))

(add-hook 'fundamental-mode-hook
         (lambda () (electric-indent-local-mode -1)))

(use-package hungry-delete
  :config
  (global-hungry-delete-mode)
  (setq hungry-delete-join-reluctantly t)
  ;; I use 'backward-delete-char, so I've got to remap it as well
  (if (fboundp 'backward-delete-char)
    (define-key hungry-delete-mode-map [remap backward-delete-char] 'hungry-delete-backward)))

(provide 'init-textmanipulation)
;;; init-textmanipulation.el ends here
