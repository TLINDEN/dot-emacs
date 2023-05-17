;;; *** Smarter M-x Mode (smex)

;; This is really cool and I don't know how I could ever live without it.
;; (use-package smex
;;              :config
;;              (smex-initialize)
;;              (global-set-key (kbd "M-x") 'smex)
;;              (global-set-key (kbd "M-X") 'smex-major-mode-commands))


(use-package vertico
  :init
  (vertico-mode)
  (require 'vertico-directory)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setq vertico-cycle t)

  :config

  (defun tvd-vertico-jump-home()
    "quickly go to home via ~ in minibuffer find-file
via [[http://whattheemacsd.com/setup-ido.el-02.html][whattheemacs.d]]"
    (interactive)
    (if (looking-back "/")
        (progn
          (backward-kill-sentence)
          (insert "~/"))
      (call-interactively 'self-insert-command)))

  :bind (:map vertico-map
              ("~" . tvd-vertico-jump-home)
              ("RET" . #'vertico-directory-enter)
              ;; experimental,  pressing   tab  on  a   match  doesn't
              ;; complete it but show the next match, that way I avoid
              ;; being completed into nonsense matches
              ("TAB" . #'vertico-next)))




(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(substring orderless basic)
        orderless-matching-styles '(orderless-prefixes)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))



(use-package embark
  :ensure t

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-," . embark-dwim))        ;; good alternative: M-.


  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc.  You may adjust the Eldoc
  ;; strategy, if you want to see the documentation from multiple providers.
  (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))







;; test, replace isearch-forward-regexp first only.
;; dir: ivy/
(use-package swiper
             :config
             (setq ivy-wrap t)
             (global-set-key "\C-s" 'swiper))



(provide 'init-smarter-than-emacs)
;;; init-smarter-than-emacs ends here
