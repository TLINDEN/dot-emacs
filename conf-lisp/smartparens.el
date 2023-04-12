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
             :config
             (require 'smartparens-config)
             (require 'cl-lib)

             ;; enable sp in minibuffer as well
             ;; maybe, see: https://github.com/Fuco1/smartparens/issues/33:
             ;; (sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)
             (setq sp-ignore-modes-list
                   (delete 'minibuffer-inactive-mode sp-ignore-modes-list))

             ;; automatically enable where needed
             (add-something-to-mode-hooks
              '(rust emacs-lisp ielm lisp lisp-interaction scheme slime-repl ) 'smartparens-mode)

             ;; also in some select prog modes
             (add-something-to-mode-hooks
              '(perl ruby c c++ sh makefile config-general yaml go) 'smartparens-mode)

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

             ;;(add-hook 'smartparens-enabled-hook #'tvd-disable-par-and-pair)
             ;;(add-hook 'smartparens-enabled-hook #'turn-on-smartparens-strict-mode)

             ;; auto wrapping w/o region
             (define-key smartparens-mode-map (kbd "C-c (")  'wrap-with-parens)
             (define-key smartparens-mode-map (kbd "C-c [")  'wrap-with-brackets)
             (define-key smartparens-mode-map (kbd "C-c {")  'wrap-with-braces)
             (define-key smartparens-mode-map (kbd "C-c '")  'wrap-with-single-quotes)
             (define-key smartparens-mode-map (kbd "C-c \"") 'wrap-with-double-quotes)
             (define-key smartparens-mode-map (kbd "C-c `")  'wrap-with-back-quotes)

             ;; modification
             (define-key smartparens-mode-map (kbd "C-k")           'sp-kill-hybrid-sexp)
             (define-key smartparens-mode-map (kbd "C-<left>")      'sp-forward-slurp-sexp)
             (define-key smartparens-mode-map (kbd "C-<right>")     'sp-forward-barf-sexp)

             ;; movement
             ;; Also Check: https://github.com/Fuco1/smartparens/wiki/Working-with-expressions
             ;; (look for "quick summary for each navigation function")
             ;;
             ;; Jump after  the next  balanced expression.  If inside  one and
             ;; there is no forward exp., jump after its closing pair.
             (define-key smartparens-mode-map (kbd "C-M-<right>") 'sp-forward-sexp)
             ;; Jump before  the previous  balanced expression. If  inside one
             ;; and there is no previous exp., jump before its opening pair.
             (define-key smartparens-mode-map (kbd "C-M-<left>")  'sp-backward-sexp)
             ;; Jump up one  level from the current  balanced expression. This
             ;; means skipping  all the  enclosed expressions within  this and
             ;; then jumping after the closing pair.
             (define-key smartparens-mode-map (kbd "C-M-<up>")    'sp-up-sexp)
             ;; Jump after the opening pair  of next balanced expression. This
             ;; effectively  descends  one  level   down  in  the  "expression
             ;; hierarchy".  If there  is no  expression to  descend to,  jump
             ;; after current expression's  opening pair. This can  be used to
             ;; quickly  navigate   to  the  beginning  of   current  balanced
             ;; expression.
             (define-key smartparens-mode-map (kbd "C-M-<down>")  'sp-down-sexp)
             ;;  Jump to  the beginning  of following balanced  expression. If
             ;;  there is no  following expression on the  current level, jump
             ;;  one level up backward, effectively doing sp-backward-up-sexp.
             (define-key smartparens-mode-map (kbd "C-S-<left>")  'sp-next-sexp)
             ;; Jump to the end of  the previous balanced expression. If there
             ;; is no previous expression on the current level, jupm one level
             ;; up forward, effectively doing sp-up-sexp.
             (define-key smartparens-mode-map (kbd "C-S-<right>") 'sp-previous-sexp)

             ;; comment the whole sexp
             (define-key smartparens-mode-map (kbd ";") 'tvd-lisp-comment)

             ;; replace my global setting
             ;; FIXME: fhceck/fix M<up+down>!
             (define-key smartparens-mode-map (kbd "M-<right>")   'sp-forward-symbol)
             (define-key smartparens-mode-map (kbd "M-<left>")    'sp-backward-symbol)

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

               (define-key smartparens-mode-map (kbd "C-x (")         'hydra-smartparens/body)
               ))

;;; Parens config goes here as well

;; display matching braces
(show-paren-mode 1)

;; 'mixed: highlight all if the other paren is invisible
;; 'expression: highlight the whole sexp
(setq show-paren-style 'mixed)
