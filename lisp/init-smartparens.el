;; I'm trying  to migrate  to smart-parens, since  it supports  all of
;; paredit but can do more

;; Also look at:
;; https://github.com/Fuco1/.emacs.d/blob/master/files/smartparens.el
;; https://github.com/Fuco1/smartparens/wiki
;; https://ebzzry.io/en/emacs-pairs/

(defun tvd-disable-par-and-pair()
  "Disables Paredit and Electric-Pair-Mode if currently active.
Used when enabling smartparens-mode."
  (interactive)
  (when electric-pair-mode
    (electric-pair-mode))
  (when (fboundp 'pparedit-mode)
    (when paredit-mode
      (disable-paredit-mode))))

;; I use my own lisp comment tool until sp#942 is fixed
(defun tvd-lisp-comment ()
  (interactive)
  (if (not (looking-at "\s*\("))
      (self-insert-command 1)
    (let ((beg (point)))
      (forward-list 1)
      (when (looking-at "\s*\)")
        (insert "\n"))
      (comment-region beg (point))
      (indent-for-tab-command)
      (goto-char beg))))

(use-package smartparens
  :init
  (require 'smartparens-config)
  (require 'cl-lib)

  ;; :custom-face
  ;; (sp-show-pair-match-face ((t (:foreground "White"))))

  :hook (prog-mode config-general yaml markdown-mode ielm lisp-interaction)

  :config
  (setq sp-ignore-modes-list
        (delete 'minibuffer-inactive-mode sp-ignore-modes-list)
        sp-navigate-close-if-unbalanced t)

  ;; via https://ebzzry.io/en/emacs-pairs/:
  (defmacro def-pairs (pairs)
    "Define functions for pairing. PAIRS is an alist of (NAME . STRING)
conses, where NAME is the function name that will be created and
STRING is a single-character string that marks the opening character.

  (def-pairs ((paren . \"(\")
              (bracket . \"[\"))

defines the functions WRAP-WITH-PAREN and WRAP-WITH-BRACKET,
respectively."
    `(progn
       ,@(cl-loop for (key . val) in pairs
                  collect
                  `(defun ,(read (concat
                                  "wrap-with-"
                                  (prin1-to-string key)
                                  "s"))
                       (&optional arg)
                     (interactive "p")
                     (sp-wrap-with-pair ,val)))))

  (def-pairs ((paren . "(")
              (bracket . "[")
              (brace . "{")
              (single-quote . "'")
              (double-quote . "\"")
              (back-quote . "`")))

  (defun tvd-insert-paren-or-close-move-up ()
    "First hitting key (closing paren) executes 'sp-up-sexp, next time hitting
it, insert a closing paren. Requires viking mode to be installed."
  (interactive)
  (let* ((key-times (viking-last-key-repeats)))
    (cond
     ((> key-times 1)
      (progn
        (message "inserting )")
        (insert ")")))
     ((eq key-times 1)
      (progn
        (message "sp-up-sexp")
        (call-interactively #'sp-up-sexp))))))

  (when (fboundp 'defhydra)
    (defhydra hydra-smartparens (:hint nil)
      "
Sexps [quit with _q_, reach this hydra with 'C-x (']

^Nav^                       ^Barf/Slurp^                           ^Depth^
^---^-----------------------^----------^---------------------------^-----^-----------------
_f_: forward  (C-M-right)   _→_:          slurp forward (C-right)  _R_: splice
_b_: backward (C-M-left)    _←_:          barf forward  (C-left)   _r_: raise
_u_: backward ↑             _C-<right>_:  slurp backward           _↑_: raise backward
_d_: forward  ↓ (C-M-down)  _C-<left>_:   barf backward            _↓_: raise forward
_p_: backward ↓
_n_: forward  ↑ (C-M-up)

^Kill^           ^Misc^                       ^Wrap^
^----^-----------^----^-----------------------^----^------------------
_w_: copy        _j_: join                    _(_: wrap with ( )
_k_: kill (C-k)  _s_: split                   _{_: wrap with { }
^^               _t_: transpose               _'_: wrap with ' '
^^               _c_: convolute               _\"_: wrap with \" \"
^^               _i_: indent defun

"
      ("q" nil)
      ;; Wrapping
      ("(" (lambda (_) (interactive "P") (sp-wrap-with-pair "(")))
      ("{" (lambda (_) (interactive "P") (sp-wrap-with-pair "{")))
      ("'" (lambda (_) (interactive "P") (sp-wrap-with-pair "'")))
      ("\"" (lambda (_) (interactive "P") (sp-wrap-with-pair "\"")))
      ;; Navigation
      ("f" sp-forward-sexp )
      ("b" sp-backward-sexp)
      ("u" sp-backward-up-sexp)
      ("d" sp-down-sexp)
      ("p" sp-backward-down-sexp)
      ("n" sp-up-sexp)
      ;; Kill/copy
      ("w" sp-copy-sexp)
      ("k" sp-kill-sexp)
      ;; Misc
      ("t" sp-transpose-sexp)
      ("j" sp-join-sexp)
      ("s" sp-split-sexp)
      ("c" sp-convolute-sexp)
      ("i" sp-indent-defun)
      ;; Depth changing
      ("R" sp-splice-sexp)
      ("r" sp-splice-sexp-killing-around)
      ("<up>" sp-splice-sexp-killing-backward)
      ("<down>" sp-splice-sexp-killing-forward)
      ;; Barfing/slurping
      ("<left>"     sp-forward-slurp-sexp)
      ("<right>"    sp-forward-barf-sexp)
      ("C-<left>"   sp-backward-barf-sexp)
      ("C-<right>"  sp-backward-slurp-sexp))

    (define-key smartparens-mode-map (kbd "C-x (")         'hydra-smartparens/body))

  :bind (:map smartparens-mode-map
              ;; auto wrapping w/o region
              ( "C-c (" .  'wrap-with-parens)
              ( "C-c [" .  'wrap-with-brackets)
              ( "C-c {" .  'wrap-with-braces)
              ( "C-c '" .  'wrap-with-single-quotes)
              ( "C-c \"" . 'wrap-with-double-quotes)
              ( "C-c `" .  'wrap-with-back-quotes)

              ;; modification
              ("C-k" .           'sp-kill-hybrid-sexp)
              ("C-<left>" .      'sp-forward-slurp-sexp)
              ("C-<right>" .     'sp-forward-barf-sexp)

              ;; movement
              ;; Also Check: https://github.com/Fuco1/smartparens/wiki/Working-with-expressions
              ;; (look for "quick summary for each navigation function")
              ;;
              ;; Jump after  the next  balanced expression.  If inside  one and
              ;; there is no forward exp., jump after its closing pair.
              ("C-M-<right>" . 'sp-forward-sexp)
              ;; Jump before  the previous  balanced expression. If  inside one
              ;; and there is no previous exp., jump before its opening pair.
              ("C-M-<left>" .  'sp-backward-sexp)
              ;; Jump up one  level from the current  balanced expression. This
              ;; means skipping  all the  enclosed expressions within  this and
              ;; then jumping after the closing pair.
              ("C-M-<up>" .    'sp-up-sexp)
              ;; Jump after the opening pair  of next balanced expression. This
              ;; effectively  descends  one  level   down  in  the  "expression
              ;; hierarchy".  If there  is no  expression to  descend to,  jump
              ;; after current expression's  opening pair. This can  be used to
              ;; quickly  navigate   to  the  beginning  of   current  balanced
              ;; expression.
              ("C-M-<down>" .  'sp-down-sexp)
              ;;  Jump to  the beginning  of following balanced  expression. If
              ;;  there is no  following expression on the  current level, jump
              ;;  one level up backward, effectively doing sp-backward-up-sexp.
              ("C-S-<left>" .  'sp-previous-sexp)
              ;; Jump to the end of  the previous balanced expression. If there
              ;; is no previous expression on the current level, jupm one level
              ;; up forward, effectively doing sp-up-sexp.
              ("C-S-<right>" . 'sp-next-sexp)

              ;; comment the whole sexp
              (";" . 'tvd-lisp-comment)

              ;; move  up  closing  parens or insert closing paren
              (")" . #'tvd-insert-paren-or-close-move-up)

              ;; replace my global setting
              ;; FIXME: fhceck/fix M<up+down>!
              ("M-<right>" .   'sp-forward-symbol)
              ("M-<left>" .    'sp-backward-symbol)))

;;; Parens config goes here as well

;; display matching parens, braces, brackets etc
(show-paren-mode 1)

;; show matching parens as white on green
(set-face-background 'show-paren-match "#228b22")
(set-face-foreground 'show-paren-match "#fff")
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)

;; mismatching ones as white on red
(set-face-background 'show-paren-mismatch "#b22222")
(set-face-foreground 'show-paren-mismatch "#fff")

;; 'mixed: highlight all if the other paren is invisible
;; 'expression: highlight the whole sexp
(setq show-paren-style 'mixed)


(provide 'init-smartparens)
;;; init-smartparens.el ends here
