;; ** More scratch space
;; *** Text scratch
;; Sometimes  I need  a  text  mode scratch  buffer  while scratch  is
;; already in use. So let's prepare one. I also add a buffer hook so that
;; this never gets deleted, but cleaned instead.

(with-current-buffer (get-buffer-create "*text*")
  (text-mode))

;; *** Autoscratch
;; use autoscratch otherwise
;; [[https://github.com/TLINDEN/autoscratch][autoscratch github]]
(use-package autoscratch
  :ensure nil
  :config
  (setq initial-major-mode 'autoscratch-mode)
  (add-hook 'autoscratch-mode-hook '(lambda ()
                                      (setq autoscratch-triggers-alist
                                            '(("[(;]"         . (progn
                                                                  (call-interactively 'emacs-lisp-mode)
                                                                  (call-interactively 'enable-paredit-mode)
                                                                  (call-interactively 'electric-pair-mode)))
                                              ("#"            . (progn
                                                                  (call-interactively 'config-general-mode)
                                                                  (electric-indent-local-mode t)))
                                              ("[-a-zA-Z0-9]" . (text-mode))
                                              ("/"            . (c-mode))
                                              ("*"            . (progn (insert " ") (org-mode)))
                                              ("."            . (fundamental-mode)))
                                            autoscratch-trigger-on-first-char t
                                            autoscratch-reset-default-directory t)
                                      (electric-indent-local-mode nil)
                                      ))
  (defalias 'scratch 'autoscratch-buffer))

;;; *** Persistent Scratch
;; I also like to be scratch buffers persistent with
;; [[https://github.com/Fanael/persistent-scratch][persistent-scratch]]

(defun tvd-autoscratch-p ()
  "Return non-nil if the current buffer is a scratch buffer"
  (string-match "scratch*" (buffer-name)))

(use-package persistent-scratch
             :config
             (setq persistent-scratch-save-file (expand-file-name "scratches.el" user-emacs-directory))
             (persistent-scratch-setup-default)

             (setq persistent-scratch-scratch-buffer-p-function 'tvd-autoscratch-p))


(provide 'init-autoscratch)
;;; init-autoscratch.el ends here
