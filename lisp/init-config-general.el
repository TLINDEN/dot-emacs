;; *** Config::General mode
;; **** Config and doc
;; [[https://github.com/TLINDEN/config-general-mode][config-general-mode]] (also on Melpa).

;; My own mode for [[http://search.cpan.org/dist/Config-General/][Config::General]]
;; config files. Whenever I write some perl stuff, which needs a config file, I use
;; this module (and I do this a lot). Previously I used conf-mode or html-mode, but
;; both did not satisfy me. Now (as of 20170625) I solved this mess once and for all.

(use-package config-general-mode
             :ensure nil ;; static install

             :config
             (require 'sh-script)

             (when (fboundp 'hippie-expand)
               (defun config-general-completion-at-point ()
                 "Complete word at point using hippie-expand, if not on a comment."
                 (interactive)
                 (when (looking-back "[-%$_a-zA-Z0-9]")
                   (unless (eq (get-text-property (point) 'face) 'font-lock-comment-face)
                     (hippie-expand nil))))

               (local-set-key (kbd "<tab>") 'config-general-tab-or-expand)

               ;; Inserting a brace or quote automatically inserts the matching pair
               ;; use smartparens now
               ;; (electric-pair-mode t)
               (setq-local hippie-expand-only-buffers '(config-general-mode))

               ;; configure order of expansion functions
               (if (version< emacs-version "25.1")
                   (set (make-local-variable 'hippie-expand-try-functions-list)
                        '(try-expand-dabbrev ;; use patched version
                          config-general--try-expand-dabbrev-all-buffers
                          try-complete-file-name-partially
                          try-complete-file-name))
                 (set (make-local-variable 'hippie-expand-try-functions-list)
                      '(try-expand-dabbrev
                        try-expand-dabbrev-all-buffers
                        try-complete-file-name-partially
                        try-complete-file-name))))

             (defun config-general-do-electric-tab ()
               "Enter a <TAB> or goto current indentation."
               (interactive)
               (if (eq (point) (line-end-position))
                   (indent-for-tab-command)
                 (back-to-indentation)))

             ;; FIXME: Use this  patched version for older emacsen  and the default
             ;; for version which contain the patch (if any, ever).
             ;;
             ;; The original  function try-expand-dabbrev-all-buffers  doesn't work
             ;; correctly, it ignores a buffer-local configuration of the variables
             ;; hippie-expand-only-buffers  and hippie-expand-ignore-buffers.  This
             ;; is the patched version of the function.
             ;;
             ;; Bugreport: http://debbugs.gnu.org/cgi/bugreport.cgi?bug=27501
             (defun config-general--try-expand-dabbrev-all-buffers (old)
               "Try to expand word \"dynamically\", searching all other buffers.
The argument OLD has to be nil the first call of this function, and t
for subsequent calls (for further possible expansions of the same
string).  It returns t if a new expansion is found, nil otherwise."
               (let ((expansion ())
                     (buf (current-buffer))
                     (orig-case-fold-search case-fold-search)
                     (heib hippie-expand-ignore-buffers)
                     (heob hippie-expand-only-buffers)
                     )
                 (if (not old)
                     (progn
                       (he-init-string (he-dabbrev-beg) (point))
                       (setq he-search-bufs (buffer-list))
                       (setq he-searched-n-bufs 0)
                       (set-marker he-search-loc 1 (car he-search-bufs))))

                 (if (not (equal he-search-string ""))
                     (while (and he-search-bufs
                                 (not expansion)
                                 (or (not hippie-expand-max-buffers)
                                     (< he-searched-n-bufs hippie-expand-max-buffers)))
                       (set-buffer (car he-search-bufs))
                       (if (and (not (eq (current-buffer) buf))
                                (if heob
                                    (he-buffer-member heob)
                                  (not (he-buffer-member heib))))
                           (save-excursion
                             (save-restriction
                               (if hippie-expand-no-restriction
                                   (widen))
                               (goto-char he-search-loc)
                               (setq expansion
                                     (let ((case-fold-search orig-case-fold-search))
                                       (he-dabbrev-search he-search-string nil)))
                               (set-marker he-search-loc (point))
                               (if (not expansion)
                                   (progn
                                     (setq he-search-bufs (cdr he-search-bufs))
                                     (setq he-searched-n-bufs (1+ he-searched-n-bufs))
                                     (set-marker he-search-loc 1 (car he-search-bufs))))))
                         (setq he-search-bufs (cdr he-search-bufs))
                         (set-marker he-search-loc 1 (car he-search-bufs)))))

                 (set-buffer buf)
                 (if (not expansion)
                     (progn
                       (if old (he-reset-string))
                       ())
                   (progn
                     (he-substitute-string expansion t)
                     t))))

             (electric-indent-mode)

             ;; de-activate some senseless bindings
             (local-unset-key (kbd "C-c C-c"))
             (local-unset-key (kbd "C-c C-p"))
             (local-unset-key (kbd "C-c C-u"))
             (local-unset-key (kbd "C-c C-w"))
             (local-unset-key (kbd "C-c C-x"))
             (local-unset-key (kbd "C-c :"))

             ;; from shell-script-mode, turn << into here-doc
             (sh-electric-here-document-mode 1))


(provide 'init-config-general)
;;; init-config-general.el ends here
