;; *** ANSI-TERM (inferior shells/interpreters and REPLs)

;; I use ansi term for inferior shells only.

;; via [[http://echosa.github.io/blog/2012/06/06/improving-ansi-term/][echosa]]

;; kill buffer when done
(defadvice term-sentinel (around tvd-advice-term-sentinel (proc msg))
  (if (memq (process-status proc) '(signal exit))
      (let ((buffer (process-buffer proc)))
        ad-do-it
        (kill-buffer buffer))
    ad-do-it))
(ad-activate 'term-sentinel)

;; force utf8
(defun tvd-term-use-utf8 ()
  (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(add-hook 'term-exec-hook 'tvd-term-use-utf8)

;; make C-y work
(defun tvd-term-paste (&optional string)
                      (interactive)
                      (process-send-string
                       (get-buffer-process (current-buffer))
                       (if string string (current-kill 0))))

;; put all term hooks in here
(defun tvd-term-hook ()
  (goto-address-mode)
  (define-key term-raw-map (kbd "C-y") 'tvd-term-paste)
  (define-key term-raw-map (kbd "C-c C-d") 'kill-this-buffer)
  (define-key term-raw-map (kbd "C-d") 'kill-this-buffer)
  (define-key term-raw-map (kbd "C-c C-l") 'term-line-mode)
  (define-key term-raw-map (kbd "C-k")
    (lambda ()
      (interactive)
      (term-send-raw-string "\C-k")
      (kill-line))))
(add-hook 'term-mode-hook 'tvd-term-hook)

;; via [[https://www.emacswiki.org/emacs/AnsiTermHints#toc4][emacswiki]]:
;; Use to supply commandline arguments to ansi-term
(defun term-with-args (new-buffer-name cmd &rest switches)
  (setq term-ansi-buffer-name (concat "*" new-buffer-name "*"))
  (setq term-ansi-buffer-name (generate-new-buffer-name term-ansi-buffer-name))
  (setq term-ansi-buffer-name (apply 'make-term term-ansi-buffer-name cmd nil switches))
  (set-buffer term-ansi-buffer-name)
  (term-mode)
  (term-char-mode)
  (message "Line mode: C-c C-l, Char mode: C-c C-k, Exit: C-c C-d")
  (switch-to-buffer term-ansi-buffer-name))

;; finally the inferior REPLs:
(defun iperl ()
  "interactive perl (via perlbrew if exist or global)"
  (interactive)
  (let ((perlbrew (expand-file-name "~/perl5/perlbrew/bin/perlbrew")))
    (if (file-exists-p perlbrew)
        (term-with-args "*perlbrew-de0*" perlbrew "exec" "--" "perl" "-de0")
      (term-with-args "*perl-de0*" "perl" "-de0"))))

(defun iruby ()
  "interactive ruby"
  (interactive)
  (term-with-args "*ruby-irb*" "irb"))

(defun ipython ()
  "interactive python"
  (interactive)
  (setenv "PYTHONSTARTUP" (expand-file-name "~/.pythonrc"))
  (term-with-args "*python-i*" "python" "-i"))

(defun icalc ()
  "interactive calc"
  (interactive)
  (term-with-args "*calc*" (expand-file-name "~/bin/calc")))
