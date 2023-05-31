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

(defun tvd-vertico-jump-root()
    "quickly go to root dir with / in minibuffer find-file, if we are in a local fs"
    (interactive)
    (if (file-directory-p (file-name-directory (minibuffer-contents-no-properties)))
        (progn
          (backward-kill-sentence)
          (insert "/"))
      (call-interactively 'self-insert-command)))

  (defun tvd-vertico-jump-ssh()
    "replaces current minibuffer input with  /ssh: so that I can edit
a remote file  anytime and from everywhere I am  by just entering :"
    (interactive)
    (if (looking-back "/")
        (progn
          (backward-kill-sentence)
          (insert "/ssh:"))
      (call-interactively 'self-insert-command)))

  (defun tvd-vertico-del-dir()
    "delete directory name in current minibuffer, if it is a directory."
    (interactive)
    (if (file-directory-p (minibuffer-contents-no-properties))
        (progn
          (if (looking-back "/")
              (delete-char -1))
          (if (search-backward "/" nil t)
              (let ((beg (+ (point) 1)))
              (end-of-buffer)
              (delete-region beg (point)))
            (delete-char -1)))
      (delete-char -1)))

  ;; via vertico wiki, prefix current candidate with an arrow
  (defvar +vertico-current-arrow t)
  (cl-defmethod vertico--format-candidate :around
    (cand prefix suffix index start &context ((and +vertico-current-arrow
                                                   (not (bound-and-true-p vertico-flat-mode)))
                                              (eql t)))
    (setq cand (cl-call-next-method cand prefix suffix index start))
    (if (bound-and-true-p vertico-grid-mode)
        (if (= vertico--index index)
            (concat #("▶" 0 1 (face vertico-current)) cand)
          (concat #("_" 0 1 (display " ")) cand))
      (if (= vertico--index index)
          (concat
           #(" " 0 1 (display (left-fringe right-triangle vertico-current)))
           cand)
        cand)))

  :bind (:map vertico-map
              ("~" . tvd-vertico-jump-home)
              (":" . tvd-vertico-jump-ssh)
              ("/" . tvd-vertico-jump-root) ;; experimental, not sure wether to keep this
              ("<backspace>" . tvd-vertico-del-dir)
              ("RET" . #'vertico-directory-enter)
              ;; experimental,  pressing   tab  on  a   match  doesn't
              ;; complete it but show the next match, that way I avoid
              ;; being completed into nonsense matches

              ;; FIXME: set this to complete*
              ;; ("TAB" . #'vertico-next)
              ;; next try: use vanilla complete on tab, maybe better?
              ("TAB" . #'minibuffer-complete)))




(use-package orderless
  :init
  ;; I  am using  the  actual  orderless completion  style  as a  last
  ;; resort. Although it  is very flexible, it requires me  to enter a
  ;; space (or  whatever one configures  as separator), which  is also
  ;; annoying.   So, I  start  with emacs  standard  (basic), if  that
  ;; doesn't suffice, initials  finds commands by initials  which I am
  ;; used to  because smex  worked that way  already. If  that doesn't
  ;; suffice  I use  the  flex  style which  is  fuzzy searching  (w/o
  ;; separator) just like  what smex did as well. And  only after that
  ;; comes orderless.  Maybe  I'll change this in the  future or throw
  ;; orderless completely away...

  ;; PS: the  file category  override now starts  with 'basic  so that
  ;; tramp     hostname     completion     works     properly,     see
  ;; https://github.com/minad/vertico#tramp-hostname-and-username-completion
  (setq completion-styles '(basic initials flex orderless)
        orderless-matching-styles '(orderless-prefixes)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-completion)))))



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


(use-package consult
  :defer nil ;; the alias doesn't work otherwise
  
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-x b" . consult-buffer)
         ("C-c C-j" . consult-imenu)
         ("C-x C-r" . consult-recent-file)) ;; replaces recentf

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  :custom
  ;; FIXME: does not ignore .git etc, try ripgrep or ag
  (consult-grep-args "grep --null --line-buffered --color=never --ignore-case\
     --with-filename --line-number -I -r -A1 -B1 --exclude-from=.gitignore")
  (consult-narrow-key "<")
  (consult-widen-key ">")

  :config
  (defalias 'egrep 'consult-ripgrep)

  (when (fboundp 'persp-new)
    (consult-customize consult--source-buffer :hidden t :default nil)

    (defvar consult--source-perspective
      (list :name     "Perspective"
            :narrow   ?s
            :category 'buffer
            :state    #'consult--buffer-state
            :default  t
            :items    #'persp-get-buffer-names))

    (push consult--source-perspective consult-buffer-sources)))


;; change directory while opening a file etc
(use-package consult-dir
  :ensure t
  :bind (("C-x C-d" . consult-dir)
         :map vertico-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file)

         :map minibuffer-local-completion-map
         ("C-x C-d" . consult-dir)))



(use-package
  embark-consult
  :after (embark consult))



;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :ensure nil ; builtin
  :init
  (savehist-mode))


;; clever and nice looking  and feeling completion package, candidates
;; show up in a mini popup, very nice
(use-package corfu
  :hook ((prog-mode . corfu-mode))

  :custom
  (corfu-quit-no-match t)
  (corfu-auto nil)
  (corfu-cycle t)
  (corfu-preselect 'prompt)

   :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous)))


;; much better  experience to seach current  buffer consult-line would
;; do the job  as well and looks  similar, but I'm used  to swiper, so
;; stick with it.
(use-package swiper
             :config
             (setq ivy-wrap t)
             (global-set-key "\C-s" 'swiper))



(provide 'init-smarter-than-emacs)
;;; init-smarter-than-emacs ends here
