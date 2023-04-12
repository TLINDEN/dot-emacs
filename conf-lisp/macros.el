;; *** MACROs

;; help: [[https://www.emacswiki.org/emacs/KeyboardMacrosTricks][emacswiki macro tricks]].

;; Default keybindings:
;; start-kbd-macro default binding: ‘C-x (’     — Starts recording a keyboard macro.
;; end-kbd-macro default binding: ‘C-x )’       — Ends recording of a keyboard macro.
;; call-last-kbd-macro default binding: ‘C-x e’ — Executes the last keyboard macro defined.

;; however, I use [[https://github.com/Silex/elmacro][elmacro]].

(use-package elmacro
             :config
             (elmacro-mode)

             (setq tvd-macro-name "last-macro")

             ;; ignore stuff
             (add-to-list 'elmacro-unwanted-commands-regexps "^(mouse.*)$")
             (add-to-list 'elmacro-unwanted-commands-regexps "^(tvd-start-or-stop-macro)$")

             (defun tvd-get-macro-name()
               "Ask for a macro name, check for duplicates.
If the given name is already defined, ask again (and again until unique).
If a buffer with the given name exists, kill it (that is, the buffer is
there but has not been saved or evaluated yet). Return the name as string."
               (interactive)
               (let ((done nil)
                     (name nil)
                     (mbuf nil)
                     (err ""))
                 (while (not done)
                   (setq name (read-string
                               (format "%s - enter macro name (last-macro): " err) nil nil "last-macro"))
                   (if (fboundp (intern name))
                       (setq err (format "macro '%s is already defined" name))
                     (setq mbuf (format "* elmacro - %s *" name))
                     (if (get-buffer mbuf)
                         (with-current-buffer mbuf
                           (kill-buffer mbuf)))
                     (setq done t)))
                 name))

             (defun tvd-get-exec-macro-name()
               "Ask for a macro name to be executed"
               (interactive)
               (let ((macros ())
                     (N 1)
                     (S nil)
                     (T ""))
                 (dolist (entry (cdr (assoc tvd-macro-file load-history )))
                   (setq S (cdr entry))
                   (setq T (symbol-name S))
                   (push (list T N) macros)
                   (setq N (1+ N)))
                 (completing-read "enter macro name: " macros nil t nil)))

             ;; the heart of my elmacro stuff
             (defun tvd-start-or-stop-macro()
               "start macro or stop if started"
               (interactive)
               (if (eq defining-kbd-macro nil)
                   (progn
                     (elmacro-clear-command-history)
                     (start-kbd-macro nil)
                     (message "Recording macro. Finish with <shift-F6> ..."))
                 (progn
                   (call-interactively 'end-kbd-macro)
                   (setq tvd-macro-name (tvd-get-macro-name))
                   (elmacro-show-last-macro tvd-macro-name)
                   (message "Recording done. Execute with <C-F6>, save or <C-x C-e> buffer..."))))

             ;; better than the default function
             (defun tvd-exec-last-macro(&optional ARG)
               "execute last macro (or ARG, if given) repeatedly after every
<ret>, abort with C-g or q, and repeat until EOF after pressing a.

If macro defun is known (i.e. because you evaluated the elmacro buffer
containing the generated defun), it will be executed. Otherwise the
last kbd-macro will be executed."
               (interactive)
               (let ((melm-count 0)
                     (melm-all nil)
                     (melm-abort nil)
                     (melm-beg (eobp))
                     (melm-code (or ARG tvd-macro-name)))
                 (if (eobp)
                     (if (yes-or-no-p "(point) is at end of buffer. Jump to top?")
                         (goto-char (point-min))))
                 (while (and (not melm-abort)
                             (not (eobp)))
                   (when (not melm-all)
                     (message (concat
                               (format
                                "Executing last macro '%s (%d). Keys:\n"  melm-code melm-count)
                               "<enter>      repeat once\n"
                               "a            repeat until EOF\n"
                               "e            enter macro name to execute\n"
                               "<C-g> or q   abort ..\n "))
                     (setq K (read-event))
                     (cond ((or (eq K 'return) (eq K 'C-f6)) t)
                           ((equal (char-to-string K) "q") (setq melm-abort t))
                           ((equal (char-to-string K) "a") (message "Repeating until EOF")(setq melm-all t))
                           ((equal (char-to-string K) "e") (setq tvd-macro-name (tvd-get-exec-macro-name)))
                           (t (setq melm-abort t))))
                   (if (not melm-abort)
                       (progn
                         (if (fboundp (intern melm-code))
                             (call-interactively (intern melm-code))
                           (call-interactively 'call-last-kbd-macro))
                         (setq melm-count (1+ melm-count)))))
                 (if (and (eq melm-count 0) (eq (point) (point-max)))
                     (message "(point) is at end of buffer, aborted")
                   (message (format "executed '%s %d times" melm-code melm-count)))))

             ;; My macro recording workflow:
             ;; - shift-F6
             ;; - ... do things  ...
             ;; - shift-F6 again
             ;; - enter a  name
             ;; - a new buffer with macro defun appears
             ;; - C-x C-e evals it
             ;; - C-F6 (repeatedly) executes it.
             (global-set-key (kbd "<f6>")            'tvd-start-or-stop-macro)
             (global-set-key (kbd "<C-f6>")          'tvd-exec-last-macro)

             ;; I use my own macro file
             (setq tvd-macro-file (concat tvd-config-dir "/macros.el"))

             ;; but only load if in use
             (if (file-exists-p tvd-macro-file)
                 (load-file tvd-macro-file))

             (defun tvd-macro-store()
               "store current macro to emacs config"
               (interactive)
               (copy-region-as-kill (point-min) (point-max))
               (if (not (get-buffer "macros.el"))
                   (find-file tvd-macro-file))
               (with-current-buffer "macros.el"
                 (goto-char (point-max))
                 (newline)
                 (insert ";;")
                 (newline)
                 (insert (format ";; elmacro added on %s" (current-time-string)))
                 (newline)
                 (yank)
                 (newline)
                 (save-buffer))
               (switch-to-buffer nil)
               (delete-window))

             (defalias 'ms        'tvd-macro-store)

             (defun tvd-macro-gen-repeater-and-save()
               "generate repeater and save the defun's
Runs when (point) is at 0,0 of generated
defun."
               (next-line)
               (goto-char (point-max))
               (newline)
               (insert (format "(defun %s-repeat()\n" tvd-macro-name))
               (insert "  (interactive)\n")
               (insert (format "  (tvd-exec-last-macro \"%s\"))\n" tvd-macro-name))
               (newline)
               (eval-buffer)
               (tvd-macro-store))

             (advice-add 'elmacro-show-defun :after '(lambda (&rest args)
                                                       (tvd-macro-gen-repeater-and-save))))
