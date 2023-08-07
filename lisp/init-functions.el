;; * Productivity Functions
;; --------------------------------------------------------------------------------
;; ** goto line with tmp line numbers

;; I stole this somewhere, as far as I remember, emacswiki, however, I
;; always had F7 for goto-line

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (display-line-numbers-mode 1)
        (call-interactively 'goto-line))
    (display-line-numbers-mode -1)))

(global-set-key (kbd "<f7>")            'goto-line-with-feedback)

;; --------------------------------------------------------------------------------
;; ** invert fore- and background

;; Sometimes when  sitting in a  very dark enviroment, my  usual light
;; emacs frame is  a too stark contrast to the  environment. With this
;; function  I can  just  invert  my current  color  settings to  dark
;; background and light foreground.

;; remember last inverse
(defvar tvd-invert-state t)

;; invert everything, reverse it when called again
(defun tvd-invert()
  "invert fg-bg"
  (interactive)
  (invert-face 'default)
  (invert-face 'mode-line)
  (set-face-attribute 'fringe nil :inverse-video tvd-invert-state)
  (setq tvd-invert-state (not tvd-invert-state)) ;; cycle variable tvd-invert-state
  )

;; fast
(global-set-key (kbd "C-c C-i")           'tvd-invert)

;; --------------------------------------------------------------------------------
;; ** Some useful bindings  for Home and End keys Hit  the key once to

;; Go to the beginning/end  of a line, hit it twice in a  row to go to
;; the beginning/end of  the window, three times in a  row goes to the
;; beginning/end of the buffer.  NB that there is no timeout involved.

;; Uses a function of viking-mode to establish key repeats, see below.

(defun pc-keys-home ()
  "Go to beginning of  line/window/buffer. First hitting key goes
to  beginning of  line,  second in  a row  goes  to beginning  of
window, third in a row goes to beginning of buffer."
  (interactive)
  (let* ((key-times (viking-last-key-repeats)))
    (cond
     ((eq key-times 3)
      (if mark-active
          (goto-char (point-min))
        (beginning-of-buffer)))
     ((eq key-times 2)
      (if mark-active () (push-mark))
      (move-to-window-line 0))
     ((eq key-times 1)
      (beginning-of-line)))))

(defun pc-keys-end ()
  "Go to end of  line/window/buffer. First hitting key goes
to end  of line, second  in a  row goes to  end of
window, third in a row goes to end of buffer."
  (interactive)
  (let* ((key-times (viking-last-key-repeats)))
    (cond
     ((eq key-times 3)
      (if mark-active
          (goto-char (point-max))
        (end-of-buffer)))
     ((eq key-times 2)
      (if mark-active () (push-mark))
      (move-to-window-line -1)
      (end-of-line))
     ((eq key-times 1)
      (end-of-line)))))

;; This is the most natural use for those keys
(global-set-key (kbd "<home>")          'pc-keys-home)
(global-set-key (kbd "<end>")           'pc-keys-end)



;; --------------------------------------------------------------------------------
;; ** percent function
;; by Jens Heunemann: jump to percent position into current buffer

(defun goto-percent (p)                        ;goto Prozentwert (0-100): F8
  (interactive "nProzent: ")
  (if (> (point-max) 80000)
      (goto-char (* (/ (point-max) 100) p))    ;Ueberlauf vermeiden: (max/100)*p
    (goto-char (/ (* p (point-max)) 100)))     ;Rundungsfehler verm.: (max*p)/100
  (beginning-of-line))

(global-set-key (kbd "<f8>")            'goto-percent)                                    ;F8 goto percent

;; --------------------------------------------------------------------------------
;; ** Simulate vi's % (percent) function

;; There's not  a lot  about vi[m]  I like,  but jumping  with %  to a
;; matching paren is one of THOSE features, I also need in emacs.

;; with ideas from [[https://www.emacswiki.org/emacs/NavigatingParentheses#toc2][emacswiki]]

;; If (point)  is on a paren,  jump to the matching  paren, otherwise,
;; just insert a literal ?%. Only make sense if bound to %.
;; Does not jump in inside () though
(defun jump-paren-match-or-insert-percent (arg)
"Go to  the matching  parenthesis if on  parenthesis. Otherwise
insert %. Mimics vi stle of % jumping to matching brace."
(interactive "p")
(cond ((looking-at "\\s\(\\|\{\\|\\[") (forward-list 1) (backward-char 1))
      ((and (looking-at "\\s\)\\|\}\\|\\]")
            (not (looking-back "\\s\(\\|\{\\|\\[")))
       (forward-char 1) (backward-list 1))
       (t (insert "%"))))

;; only useful in programming modes
(define-key prog-mode-map (kbd "%") 'jump-paren-match-or-insert-percent)

;; --------------------------------------------------------------------------------
;; ** Move region

;; Mark a region, then use M-up|down to move it around
;; via [[https://www.emacswiki.org/emacs/MoveRegion][emacswiki]]
;; code from [[https://github.com/targzeta/move-lines/blob/master/move-lines.el][move-lines]]

(defun move-lines--internal (n)
  (let* ((start (point)) ;; The position of beginning of line of the first line
         (end start)     ;; The position of eol+\n of the end line
         col-init        ;; The current column for the first line
         (col-end (current-column)) ;; The current column for the end line
         exchange_pm     ;; If I had exchanged point and mark
         delete-latest-newline) ;; If I had inserted a newline at the end

    ;; STEP 1: Identifying the line(s) to cut.
    ;; ---
    ;; If region is actives, I ensure that point always is at the end of the
    ;; region and mark at the beginning.
    (when (region-active-p)
      (when (< (point) (mark))
        (setq exchange_pm t)
        (exchange-point-and-mark))
      (setq start (mark)
            end (point)
            col-end (current-column)))

    (goto-char start) (setq col-init (current-column))
    (beginning-of-line) (setq start (point))

    (goto-char end) (end-of-line)
    ;; If point == point-max, this buffers doesn't have the trailing newline.
    ;; In this case I have to insert a newline otherwise the following
    ;; `forward-char' (to keep the "\n") will fail.
    (when (= (point) (point-max))
      (setq delete-latest-newline t)
      (insert-char ?\n) (forward-char -1))
    (forward-char 1) (setq end (point))

    ;; STEP 2: Moving the lines.
    ;; ---
    ;; The region I'm cutting span from the beginning of line of the current
    ;; line (or current region) to the end of line + 1 (newline) of the current
    ;; line (or current region).
    (let ((line-text (delete-and-extract-region start end)))
      (forward-line n)
      ;; If the current-column != 0, I have moved the region at the bottom of a
      ;; buffer doesn't have the trailing newline.
      (when (not (= (current-column) 0))
        (insert-char ?\n)
        (setq delete-latest-newline t))
      (setq start (+ (point) col-init)) ;; Now, start is the start of new region
      (insert line-text))

    ;; STEP 3: Restoring
    ;; ---
    ;; I'm at the end of new region (or line) and start has setted at the
    ;; beginning of new region (if a region is active).
    ;; Restoring the end column.
    (forward-line -1)
    (forward-char col-end)

    (when delete-latest-newline
      (save-excursion
        (goto-char (point-max))
        (delete-char -1)))

    (when (region-active-p)
      (setq deactivate-mark nil)
      (set-mark start)
      (if exchange_pm
          (exchange-point-and-mark)))))

(defun move-lines-up (n)
  "Moves the current line or, if region is actives, the lines surrounding
region, up by N lines, or 1 line if N is nil."
  (interactive "p")
  (if (eq n nil)
      (setq n 1))
  (move-lines--internal (- n)))

(defun move-lines-down (n)
  "Moves the current line or, if region is actives, the lines surrounding
region, down by N lines, or 1 line if N is nil."
  (interactive "p")
  (if (eq n nil)
      (setq n 1))
  (move-lines--internal n))

(global-set-key (kbd "M-<up>")          'move-lines-up)
(global-set-key (kbd "M-<down>")        'move-lines-down)

;; --------------------------------------------------------------------------------
;; ** comment-uncomment region with one key binding
;; via [[http://stackoverflow.com/a/9697222/3350881][stackoverflow]]
(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))

(global-set-key (kbd "C-c C-c")         'comment-or-uncomment-region-or-line)

;; --------------------------------------------------------------------------------
;; ** search for symbol at point

;; Simulate the # function of vi,  marks the symbol at point, C-s then
;; searches for it. I use this a lot.

;; via [[http://ergoemacs.org/emacs/modernization_isearch.html][ergomacs]]

(defun xah-search-current-word ()
  "Call `isearch' on current word or text selection.
   'word' here is A to Z, a to z, and hyphen and underline, independent of syntax table.
URL `[[http://ergoemacs.org/emacs/modernization_isearch.html'][ergomacs]]
Version 2015-04-09"
  (interactive)
  (let ( xahp1 xahp2 )
    (if (use-region-p)
        (progn
          (setq xahp1 (region-beginning))
          (setq xahp2 (region-end)))
      (save-excursion
        (skip-chars-backward "-_A-Za-z0-9")
        (setq xahp1 (point))
        (right-char)
        (skip-chars-forward "-_A-Za-z0-9")
        (setq xahp2 (point))))
    (setq mark-active nil)
    (when (< xahp1 (point))
      (goto-char xahp1))
    (isearch-mode t)
    (isearch-yank-string (buffer-substring-no-properties xahp1 xahp2))
    (message "Now use C-s to search for it ...")
    ))

(global-set-key (kbd "C-#")             'xah-search-current-word)

;; --------------------------------------------------------------------------------
;; ** Window Margin

;; Kinda screen reader  for the poor.  I use this  sometimes with info
;; or woman mode. I also use a full featured screen reader: nove-mode,
;; see below.

;; left+right margin on demand (but nothing else)
(defun margin(m)
  "set left and right margins for better readability"
  (interactive "nEnter Margin (0 to disable) [0-9]+: ")
  (set-window-margins (car (get-buffer-window-list (current-buffer) nil t)) m m) ;; set immediately
  (setq left-margin-width m) ;; persist until reset
  (setq right-margin-width m)
  (message "To reset, change Buffer or call again with arg 0.")
  )

;; --------------------------------------------------------------------------------
;; ** Fill and justify a paragraph

;; this is just a shortcut for:
;;    C-u 70 <ret> M-x fill-paragraph
;; but C-q is just easier to remember

;; however, if pressed again it un-fills the paragraph,
;; idea via: [[http://endlessparentheses.com/fill-and-unfill-paragraphs-with-a-single-key.html][endlessparentheses]]
(defun tvd-fill-and-justify-or-unfill()
  (interactive)
  (let ((fill-column
         (if (eq last-command 'tvd-fill-and-justify-or-unfill)
             (progn (setq this-command nil)
                    (point-max))
           fill-column)))
    (fill-paragraph 70)))

(global-set-key (kbd "C-q")             'tvd-fill-and-justify-or-unfill)                   ; like M-q, which is bound to x-window-quit in xmonad: fill+justify

;; --------------------------------------------------------------------------------
;; ** Make a read-only copy of the current buffer

;; I just create  a new read-only buffer and copy  the contents of the
;; current one  into it, which  can be used as  backup. I use  this in
;; cases where I need to re-factor a file and do lots of changes. With
;; the buffer copy  I have a reference to compare  without the need to
;; leave emacs and look at revision  control diffs or the like, and if
;; a file is not maintained via VC anyway.

(defvar copy-counter 0)

(defun get-copy-buffer-name()
  "return unique copy buffer name"
  (let ((name (concat "*COPY " (buffer-name (current-buffer)) " (RO)")))
    (if (not (get-buffer name))
        (progn
          (setq copy-counter (1+ copy-counter))
          (concat name "<" (number-to-string copy-counter) ">"))
      (concat name))))

(defun copy-buffer-read-only()
  "Create a read-only copy of the current buffer"
  (interactive)
  (let ((old-buffer (current-buffer))
        (new-buffer-name (get-copy-buffer-name)))
    (progn
      (delete-other-windows)
      (split-window-horizontally)
      (other-window 1)
      (if (not (eq (get-buffer new-buffer-name) nil))
          (kill-buffer (get-buffer new-buffer-name)))
      (set-buffer (get-buffer-create new-buffer-name))
      (insert-buffer-substring old-buffer)
      (read-only-mode)
      (switch-to-buffer new-buffer-name)
      (other-window 1))))

(defalias 'cp        'copy-buffer-read-only)

(global-set-key (kbd "C-c C-p")         'copy-buffer-read-only)                           ; make read-only buffer copy

;; --------------------------------------------------------------------------------
;; ** Cleanup, close all windows and kill all buffers

;; From  time  to  time  I  get annoyed  by  the  many  dozen  buffers
;; opened. In such cases I like to close them all at once.

;; No key binding though,  just in case I stumble upon  it and kill my
;; setup accidentally.

(defun kill-all-buffers ()
  "Kill all buffers, clean up, close all windows"
  (interactive)
  (when (y-or-n-p "Close all windows and kill all buffers?")
    (delete-other-windows)
    (clean-buffer-list)
    (dolist (buffer (buffer-list))
      (kill-buffer buffer))
    (delete-minibuffer-contents)
    (if (fboundp 'tramp-cleanup-all-connections)
        (tramp-cleanup-all-connections))
    (with-current-buffer (get-buffer-create "*text*")
      (text-mode))
    (autoscratch-buffer)))

;; --------------------------------------------------------------------------------
;; ** Cleanup current buffer

;; Remove TABs, leading and trailing spaces, re-indent a buffer.

;; via [[http://whattheemacsd.com/buffer-defuns.el-01.html][whattheemacs.d]]

(defun cleanup-buffer ()
  "Perform a bunch of safe operations on the whitespace content of a buffer.
Does not indent buffer, because it is used for a before-save-hook, and that
might be bad."
  (interactive)
  (untabify (point-min) (point-max))
  (delete-trailing-whitespace)
  (save-excursion
    (replace-regexp "^\n\\{3,\\}" "\n\n" nil (point-min) (point-max)))
  (set-buffer-file-coding-system 'utf-8)
  (indent-region (point-min) (point-max)))

(defalias 'cb        'cleanup-buffer)

;; related, I  use this  to cleanup directories  and rename  files and
;; directories to  my liking.  Sometimes  I get  a disk or  stick from
;; Windows  users and  they  use every  character  available on  their
;; keyboards to name files and dirs. I can't have this shit.
;;
(defun cleanup-dired-buffer ()
  "If inside a wdired (edit) buffer, rename everything"
  (interactive)
  (delete-trailing-whitespace)
  (save-excursion
    (replace-regexp "[\(\)'`#,_&\!]" "" nil (point-min) (point-max))
    (replace-string " " "-" nil (point-min) (point-max))
    (replace-regexp "--*" "-" nil (point-min) (point-max))
    (replace-string "ä" "ae" nil (point-min) (point-max))
    (replace-string "ö" "oe" nil (point-min) (point-max))
    (replace-string "ü" "ue" nil (point-min) (point-max))
    (replace-string "Ä" "Ae" nil (point-min) (point-max))
    (replace-string "Ö" "Oe" nil (point-min) (point-max))
    (replace-string "Ü" "Ue" nil (point-min) (point-max))
    (replace-string "ß" "ss" nil (point-min) (point-max))
    (replace-string ".." "." nil (point-min) (point-max))))

(defun cleanup-dir()
  "Cleanup wdired buffer in one whole step, used for emacsclient buffers"
  (interactive)
  (wdired-change-to-wdired-mode)
  (cleanup-dired-buffer)
  (wdired-finish-edit)
  (kill-this-buffer))


;; --------------------------------------------------------------------------------
;; ** Remove Umlauts and other crab in current buffer

;; converts:
;;            Stan Lem - ein schönes Leben & sonst nix(ungekuerzte Ausgabe)
;; to:
;;            Stan_Lem-ein_schoenes_Leben_sonst_nix_ungekuerzte_Ausgabe
;;
;; used in dired buffers to cleanup filenames by german windows users.
(defun umlaute-weg()
  (interactive)
  (let ((umlaute '((Ü . Ue)
                   (Ä . Ae)
                   (Ö . Oe)
                   (ü . ue)
                   (ä . ae)
                   (ö . oe)
                   (ß . ss)))
        (regs (list
               '(" "       . "_")
               '("_-_"     . "-")
               '("[\(\)&]" . "_")
               '("__*"     . "_")
               '("_$"      . "")
               )))
    (save-excursion
      (dolist (pair umlaute)
        (replace-regexp (symbol-name (car pair))
                        (symbol-name (cdr pair))
                        nil
                        (point-min) (point-max)))
      (dolist (reg regs)
        (replace-regexp (car reg) (cdr reg) nil
                        (point-min) (point-max))))))

;; --------------------------------------------------------------------------------
;; ** Better newline(s)

;; Add newline  and jump to indent  from wherever I am  in the current
;; line, that is it is not required to be on the end of line.

;; via [[http://whattheemacsd.com/editing-defuns.el-01.html][whattheemacs.d]]

(defun open-line-below ()
  (interactive)
  (end-of-line)
  (newline)
  (indent-for-tab-command))

(defun open-line-above ()
  (interactive)
  (end-of-line)
  (beginning-of-line)
  (newline)
  (forward-line -1)
  (indent-for-tab-command))

;; disabled, interferes with modes.

;; (global-set-key (kbd "<C-return>")      'open-line-below)

;; (global-set-key (kbd "<C-S-return>")    'open-line-above)

;; --------------------------------------------------------------------------------
;; ** Mouse Rectangle

;; There's not  much use for  the mouse in  emacs, but this  gimick is
;; funny and works like a charm.

;; via [[http://emacs.stackexchange.com/a/7261][stackoverflow]]
(defun mouse-start-rectangle (start-event)
  (interactive "e")
  (deactivate-mark)
  (mouse-set-point start-event)
  (rectangle-mark-mode +1)
  (let ((drag-event))
    (track-mouse
      (while (progn
               (setq drag-event (read-event))
               (mouse-movement-p drag-event))
        (mouse-set-point drag-event)))))

(global-set-key (kbd "S-<down-mouse-1>") 'mouse-start-rectangle)

;; --------------------------------------------------------------------------------
;; ** DOS <=> UNIX conversion helpers

(defun dos2unix ()
  (interactive)
  (set-buffer-file-coding-system 'utf-8-unix)
  (message (format "converted current buffer to %s" buffer-file-coding-system)))

(defun unix2dos ()
  (interactive)
  (set-buffer-file-coding-system 'utf-8-dos)
  (message (format "converted current buffer to %s" buffer-file-coding-system)))
;; --------------------------------------------------------------------------------
;; ** helper do add the same thing to multiple mode hooks
;; via [[http://stackoverflow.com/posts/3900056/revisions][stackoverflow]]
;; usage samples below.
(defun add-something-to-mode-hooks (mode-list something)
  "helper function to add a callback to multiple hooks"
  (dolist (mode mode-list)
    (add-hook (intern (concat (symbol-name mode) "-mode-hook")) something)))

;; --------------------------------------------------------------------------------

;; ** helper to catch load errors

;; Try to  eval 'fn,  catch errors,  if any but  make it  possible for
;; emacs to continue undisturbed, used with SMEX, see below.
(defmacro safe-wrap (fn &rest clean-up)
  `(unwind-protect
       (let (retval)
         (condition-case ex
             (setq retval (progn ,fn))
           ('error
            (message (format "Caught exception: [%s]" ex))
            (setq retval (cons 'exception (list ex)))))
         retval)
     ,@clean-up))
;; --------------------------------------------------------------------------------
;; ** Alignment Wrappers

;; align-regexp is already  a very usefull tool,  however, sometimes I
;; want  to repeat  the alignment  and I  hate C-u,  so here  are some
;; wrappers to make this easier.

(defun align-repeat (regex &optional alignment)
  "Aply  REGEX  to all  columns  not  just  the first.  Align  by
ALIGNMENT which must be 'left or 'right. The default is 'left.

Right alignment:

col1 ,col2
col1 ,col2

Left alignment:

col1, col2
col1, col2"
  (interactive  "MRepeat Align Regex [ ]: ")
  (let ((spc " ")
        (beg (point-min))
        (end (point-max))
        (areg "%s\\(\\s-*\\)" ; default left aligned
              ))
    (when (string= regex "")
      (setq regex spc))
    (when (region-active-p)
      (setq beg (region-beginning))
      (setq end (region-end)))
    (when (eq alignment 'right)
        (setq areg "\\(\\s-*\\)%s"))
    (align-regexp beg end (format areg regex) 1 1 t)))

(defun align-repeat-left (regex)
  (interactive  "MRepeat Left Align Regex [ ]: ")
  (align-regexp-repeat regex 'left))

(defun align-repeat-right (regex)
  (interactive  "MRepeat Left Align Regex [ ]: ")
  (align-regexp-repeat regex 'right))


;; ** String Helpers

;; Some helper functions I use here and there.

(defun tvd-alist-keys (A)
  "return a list of keys of alist A"
  (let ((K ()))
    (dolist (e A)
            (push (car e) K)
            )
    K))

(defun tvd-get-line ()
  "return current line in current buffer"
  (buffer-substring-no-properties
   (line-beginning-position)
   (line-end-position)))

(defun tvd-starts-with (s begins)
  "Return non-nil if string S starts with BEGINS."
  (cond ((>= (length s) (length begins))
         (string-equal (substring s 0 (length begins)) begins))
        (t nil)))

(defun tvd-replace-all (regex replace)
  "Replace all matches of REGEX with REPLACE in current buffer."
  (interactive)
  (goto-char (point-min))
  (while (re-search-forward regex nil t)
    (replace-match replace)))


(provide 'init-functions)
;;; init-functions.el ends here
