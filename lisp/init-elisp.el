;; *** Emacs LISP interactive

;; General configuration for all things elisp.

;; By using C-x-e I can push region or buffer
;; of lisp code (i.e. inside *scratch*) into
;; REPL where it will be evaluated

(defun tvd-get-code()
  "helper: returns marked region or the whole buffer contents"
  ;; FIXME: mv to string helpers?
  (if mark-active
      (let (  ;; save region and buffer
            (partb (buffer-substring-no-properties (region-beginning) (region-end)))
            (whole (buffer-substring-no-properties (point-min) (point-max)))
            )
        (if (> (length partb) 0)
            partb
          whole
          )
        )
    ;; no mark, also return everything
    (buffer-substring-no-properties (point-min) (point-max))))

(defun tvd-send-region-to-repl ()
  "put region or buffer into elisp repl and eval"
  (interactive)
  (let ( ;; fetch region or buffer contents
        (code  (tvd-get-code)))
    (progn
      (if (not (get-buffer "*ielm*"))
          ;; ielm not yet running, start it in split window but stay here
          (progn
            (split-window-horizontally)
            (other-window 1)
            (ielm)
            (other-window 1)))
      ;; finially, paste content into ielm and evaluate it
      ;; still we stay where we are
      (with-current-buffer "*ielm*"
        (goto-char (point-max))
        (insert code)
        (ielm-return)))))

(defun tvd-elisp-eval()
  "just eval region or buffer whatever feasible"
  (interactive)
  (progn
    (if mark-active
        (progn
          (let ((beg (mark))
                (end (point)))
            (when (> beg end) ;; point and mark are reversed
              (setq beg (point)
                    end (mark)))
            (eval-region beg end)))
      (eval-buffer))))

(defun ff ()
  "Jump to function definition at point."
  (interactive)
  (find-function-other-window (symbol-at-point)))

(defun tvd-make-defun-links ()
  "experimental: make function calls clickable, on click, jump to definition of it"
  (interactive)
  (let ((beg 0)
        (end 0)
        (fun nil))
    (goto-char (point-min))
    (while (re-search-forward "(tvd[-a-z0-9]*" nil t)
      (setq end (point))
      (re-search-backward "(" nil t)
      (forward-char 1)
      (setq beg (point))
      (setq fun (buffer-substring-no-properties beg end))
      (make-button beg end 'action
                   (lambda (x)
                     (find-function-other-window (symbol-at-point))))
      (goto-char end))))

(defun emacs-change-version (v)
  "Change version of .emacs (must be the current buffer).
Returns t if version changed, nil otherwise."
  (interactive
   (list
    (completing-read "New config version (press TAB for old): "
                     (list tvd-emacs-version))))
  (if (equal v tvd-emacs-version)
      nil
    (save-excursion
      (show-all)
      (beginning-of-buffer)
      (tvd-replace-all (format "\"%s\"" tvd-emacs-version)
                       (format "\"%s\"" v))
      (setq tvd-emacs-version v)
      (message (format "New config version set: %s" v))
      t)))

(defun emacs-change-log (entry)
  "Add a changelog entry to .emacs Changelog"
  (interactive "Menter change log entry: ")
  (let ((newversion (call-interactively 'emacs-change-version)))
      (save-excursion
        (show-all)
        (beginning-of-buffer)
        (re-search-forward ";; .. Changelog")
        (next-line)
        ;; (tvd-outshine-end-of-section)
        (when newversion
          (insert (format "\n;; %s\n" tvd-emacs-version)))
        (insert (format ";;    - %s\n" entry)))))

;; elisp config
(add-hook 'emacs-lisp-mode-hook
          (lambda()
            ;; non-separated x-e == eval hidden, aka current buffer
            (local-set-key (kbd "C-x C-e")  'tvd-elisp-eval)
            ;; separate 'e' == separate buffer
            (local-set-key (kbd "C-x e")    'tvd-send-region-to-repl)
            (setq mode-name "EL"
                  show-trailing-whitespace t)
            (eldoc-mode t)

            ;; enable outline
            ;; (outline-minor-mode)

            (electric-indent-local-mode t)))

;; use UP arrow for history in *ielm* as well, just as C-up
(add-hook 'comint-mode-hook
          (lambda()
            (define-key comint-mode-map [up] 'comint-previous-input)))

;; sometimes I use lisp in minibuffer
(defun ee()
  (interactive)
  (electric-pair-mode)
  (call-interactively 'eval-expression)
  (electric-pair-mode))

;; lets have eldoc in minibuffer as well
(add-hook 'eval-expression-minibuffer-setup-hook #'eldoc-mode)

;; sometimes I eval regions
(defalias 'er        'eval-region)

;; ... or defuns
(defalias 'ef        'eval-defun)

;; I like to have some functions fontified differently
(font-lock-add-keywords
 'emacs-lisp-mode
 '(("(\\s-*\\(eq\\|if\\|cond\\|and\\|set\\|or\\|not\\|when\\|setq\\|let**\\|lambda\\|kbd\\|defun\\|car\\|cdr\\)\\s-+"
    1 'font-lock-keyword-face)))

;; same applies for quoted symbols
(font-lock-add-keywords
 'emacs-lisp-mode
 '(("'[-a-zA-Z_][-a-zA-Z0-9_]*\\>" 0 'font-lock-constant-face)))

;; I  hate it  when help,  debug,  ielm and  other peripheral  buffers
;; litter  my emacs  window setup.  So, this  function fixes  this: it
;; opens a new frame with all those buffers already opened and pinned.

(defun dev ()
  "Open a new emacs frame with some development peripheral buffers."
  (interactive)
  (let ((F (make-frame)))
    (with-selected-frame F
      (with-current-buffer (get-buffer-create "*Help*")
        (help-mode))
      (with-current-buffer (get-buffer-create "*ielm*")
        (ielm))
      (with-current-buffer (get-buffer-create "*suggest*")
        (suggest))
      (switch-to-buffer "*ielm*")
      (split-window-horizontally)
      (split-window-vertically)
      (windmove-down)
      (switch-to-buffer "*suggest*")
      (tvd-suggest-reload)
      (tvd-suggest-reload)
      (windmove-right)
      (switch-to-buffer "*Help*")
      (split-window-vertically)
      (windmove-down)
      (switch-to-buffer "*scratch*")
      (set-window-dedicated-p (selected-window) t)
      (set-background-color "azure"))))



(provide 'init-elisp)
;;; init-elisp.el ends here
