;; *** cperl mode

;; I am  a perl addict. I  love it, therefore, emacs  must be prepared
;; for my addiction.  Most importantly,  I prefer cperl instead of the
;; default perl  mode. I do not  use the cperl version  delivered with
;; emacs though, but the latest git version.

(use-package cperl
             :ensure nil ;; builtin

             :mode ("\.pl$" . cperl-mode)
             :mode ("\.pm$" . cperl-mode)

             :config
             (defalias 'perl-mode 'cperl-mode)

             ;; enable the most important cperl features
             (setq cperl-indent-left-aligned-comments nil)
             (setq cperl-comment-column 32)
             (setq cperl-hairy t)
             (setq cperl-electric-linefeed t)
             (setq cperl-electric-keywords t)
             (setq cperl-electric-parens t)
             (setq cperl-electric-parens-string nil)

             (defun perl-kill ()
               "get rid of hanging perl compile or run buffers"
               (interactive)
               (delete-windows-on perl-run-out-buffer)
               (kill-buffer perl-run-out-buffer))

             (defun perl-run (switches parameters prefix)
               "execute current perl buffer"
               (interactive "sPerl-switches:\nsParameter:\nP")
               (let ((file buffer-file-name))
                 (if (eq prefix nil)
                     (shell-command (concat "perl " switches " " file " " parameters "&"))
                   (shell-command (concat "perl -wc " switches " " file " " parameters "&")))
                 (save-excursion
                   (set-buffer perl-run-out-buffer)
                   (setq perl-error-fontified nil
                         perl-error-start nil
                         perl-error-end nil)
                   (goto-char (point-min)))
                 ))

             (defun perl-next-error ()
               "jump to next perl run error, if any"
               (interactive)
               (let (line
                     errorfile
                     (window (get-buffer-window (buffer-name)))
                     (file buffer-file-name)
                     (buffer (buffer-name))
                     )
                 (select-window (display-buffer perl-run-out-buffer))
                 (set-buffer perl-run-out-buffer)
                 (if (eq perl-error-fontified t)
                     (progn
                       (set-text-properties perl-error-start perl-error-end ())
                       (setq perl-error-fontified nil)
                       )
                   )
                 (if (re-search-forward (concat "at \\([-a-zA-Z:0-9._~#/\\]*\\) line \\([0-9]*\\)[.,]") (point-max) t)
                     ()
                   (goto-char (point-min))
                   (message "LAST ERROR, jumping to first")
                   (re-search-forward (concat "at \\([-a-zA-Z:0-9._~#/\\]*\\) line \\([0-9]*\\)[.,]") (point-max) t)
                   )
                 (recenter)
                 (set-text-properties (match-beginning 1)
                                      (match-end 2)
                                      (list 'face font-lock-keyword-face))
                 (setq perl-error-fontified t
                       perl-error-start (match-beginning 1)
                       perl-error-end (match-end 2)
                       errorfile (buffer-substring
                                  (match-beginning 1)
                                  (match-end 1))
                       line (string-to-int (buffer-substring
                                            (match-beginning 2)
                                            (match-end 2))))
                 (select-window window)
                 (find-file errorfile)
                 (goto-line line)))

             ;; cperl indent region
             (defun own-cperl-indent-region-or-paragraph (start end)
               (interactive "r")
               (if mark-active
                   (cperl-indent-region start end)
                 (save-excursion
                   (mark-paragraph)
                   (cperl-indent-region (point) (mark t))
                   )))

             (defun tvd-cperl-hook()
               (make-variable-buffer-local 'perl-error-fontified)
                (make-variable-buffer-local 'perl-error-start)
                (make-variable-buffer-local 'perl-error-end)
                (make-variable-buffer-local 'perl-old-switches)
                (make-variable-buffer-local 'perl-old-parameters)
                (local-set-key "\C-hF" 'cperl-info-on-current-command)
                (local-set-key "\C-hf" 'describe-function)
                (local-set-key "\C-hV" 'cperl-get-help)
                (local-set-key "\C-hv" 'describe-variable)
                (local-set-key "\C-cr" 'perl-run)
                (local-set-key "\C-ck" 'perl-kill)
                (local-set-key "\C-c#" 'perl-next-error)
                (local-set-key "\M-\C-q" 'own-cperl-indent-region-or-paragraph)
                (setq mode-name "PL"))

             :hook tvd-cperl-hook)
