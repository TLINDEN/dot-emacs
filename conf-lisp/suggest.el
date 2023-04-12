;; *** Suggest Mode

;; [[https://github.com/Wilfred/suggest.el][suggest mode]] is a great
;; elisp development tool. Execute `M-x suggest' and try it.

;; FIXME: doesn't install, seems to use a different version from elpa, which requires spinner ?!?!:
;; Error (use-package): Failed to install suggest: Opening output file:
;; No such file or directory, /home/scip/.emacs-init.d/elpa-27.1/spinner-1.7.4/spinner-autoloads.el
;; spinner is here: https://elpa.gnu.org/packages/spinner.html
(when nil
  (use-package suggest
               :config

               ;; I use my own clearing function, since suggest doesn't provide this
               (defun tvd-suggest-reload ()
                 "Clear suggest buffer and re-paint it."
                 (interactive)
                 (let ((inhibit-read-only t))
                   (erase-buffer)
                   (suggest--insert-heading suggest--inputs-heading)
                   (insert "\n\n\n")
                   (suggest--insert-heading suggest--outputs-heading)
                   (insert "\n\n\n")
                   (suggest--insert-heading suggest--results-heading)
                   (insert "\n")
                   (suggest--nth-heading 1)
                   (forward-line 1)))

               (defun tvd-suggest-jump ()
                 "Jump between input and output suggest buffer."
                 (interactive)
                 (forward-line -1)
                 (if (eq (line-number-at-pos) 1)
                     (suggest--nth-heading 2)
                   (suggest--nth-heading 1))
                 (forward-line 1))

               (eval-after-load "suggest"
                 '(progn
                    (add-hook 'suggest-mode-hook
                              (lambda ()
                                (local-set-key (kbd "C-l") 'tvd-suggest-reload)
                                (local-set-key (kbd "<tab>") 'tvd-suggest-jump)))))))
