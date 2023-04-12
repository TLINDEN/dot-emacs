;;; ** increase fontsize with ctrl-+ and ctrl--

;; I use  those bindings everywhere  (firefox, terminal, etc),  and in
;; emacs as well.
;; using https://github.com/purcell/default-text-scale
(use-package default-text-scale
             :config
             (defun tvd-global-font-size-bigger ()
               "Make font size larger."
               (interactive)
               ;; (text-scale-increase 0.5)
               (default-text-scale-increase))

             (defun tvd-global-font-size-smaller ()
               "Change font size back to original."
               (interactive)
               ;; (text-scale-increase -0.5)
               (default-text-scale-decrease))

             (global-set-key (kbd "C-+") 'tvd-global-font-size-bigger)
             (global-set-key (kbd "C--") 'tvd-global-font-size-smaller))
