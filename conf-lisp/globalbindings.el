;;; * Global Key Bindings
;; --------------------------------------------------------------------------------
;; ** c-h != delete
(keyboard-translate ?\C-h ?\C-?)
(keyboard-translate ?\C-? ?\C-h)

;; --------------------------------------------------------------------------------
;; ** general keys (re-)mappings
;(global-set-key (kbd "C-s")             'isearch-forward-regexp)
;(global-set-key (kbd "C-r")             'isearch-backward-regexp)
(global-set-key (kbd "M-C-s")           'isearch-forward)
(global-set-key (kbd "M-C-r")           'isearch-backward)
(global-set-key (kbd "M-%")             'query-replace-regexp)
(global-set-key (kbd "<backtab>")       'dabbrev-completion)                              ; shift-tab, inline completion

(global-set-key (kbd "<f9>")            'html-mode)
(global-set-key (kbd "<delete>")        'delete-char)                                     ; Entf            Char loeschen
(global-set-key (kbd "<backspace>")     'backward-delete-char)                            ; Shift+Backspace dito
(global-set-key (kbd "S-<delete>")      'kill-word)                                       ; Shift+Entf      Wort loeschen
(global-set-key (kbd "S-<backspace>")   'backward-kill-word)                              ; Shift+Backspace dito
(global-set-key (kbd "C-<delete>")      'kill-word)                                       ; Shift+Entf      dito
(global-set-key (kbd "C-<backspace>")   'backward-kill-word)                              ; Shift+Backspace dito
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-x k")           'kill-this-buffer)                                ; C-x k  really kill current buffer w/o asking
(global-set-key (kbd "C-x C-b")         'buffer-menu)



;; --------------------------------------------------------------------------------
;; ** display a list of my own global key bindings and aliases
;; via [[https://www.emacswiki.org/emacs/OccurMode#toc9][emacswiki]]

;; Inside *Occur*: q - quit, e - edit, g - reload
;; more help with: describe-function occur-mode

(defun occur-mode-clean-buffer ()
  "Removes all commentary from the *Occur* buffer, leaving the
 unadorned lines."
  (interactive)
  (if (get-buffer "*Occur*")
      (save-excursion
        (set-buffer (get-buffer "*Occur*"))
        (goto-char (point-min))
        (toggle-read-only 0)
        (if (looking-at "^[0-9]+ lines matching \"")
            (kill-line 1))
        (while (re-search-forward "^[ \t]*[0-9]+:"
                                  (point-max)
                                  t)
          (replace-match "")
          (forward-line 1)))
    (message "There is no buffer named \"*Occur*\".")))

(defun show-definition(REGEX)
  (interactive)
  (let ((dotemacs-loaded nil)
        (occur-b "*Occur*")
        (occur-c ""))
    (if (get-buffer ".emacs")
        (progn
          (switch-to-buffer ".emacs")
          (setq dotemacs-loaded t))
      (find-file "~/.emacs"))
    (occur REGEX)
    (with-current-buffer occur-b
      (occur-mode-clean-buffer)
      (setq occur-c (current-buffer))
      (let ((inhibit-read-only t)) (set-text-properties (point-min) (point-max) ()))
      (while (re-search-forward "[0-9]*:" nil t)
        (replace-match ""))
      (beginning-of-buffer)
      (kill-line)
      (sort-lines nil (point-min) (point-max))
      (emacs-lisp-mode)
      (beginning-of-buffer)
      (insert (format ";; *SHOW*:   %s\n" REGEX))
      (highlight-regexp REGEX)
      (beginning-of-buffer))
    (switch-to-buffer occur-b)
    (delete-other-windows)
    (if (eq dotemacs-loaded nil)
        (kill-buffer ".emacs"))))

(defun show-keys()
  (interactive)
  (show-definition "^(global-set-key"))

(defun show-aliases()
  (interactive)
  (show-definition "^(defalias"))

(defalias 'sk        'show-keys)
(defalias 'sa        'show-aliases)
