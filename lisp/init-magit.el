;; *** Magit

;; TODO: add blamer.el (https://github.com/Artawower/blamer.el), currently fails to install (2023/05/08)

;; Not much to  say about Magit
(use-package magit
  :ensure t

  :init
  (use-package magit-todos)

  :config
  (magit-todos-mode)

  (defun tvd-magit-status ()
    "Always call `magit-status' with prefix arg."
    (interactive)
    (let ((current-prefix-arg t))
      (call-interactively 'magit-status)))

  (setq magit-view-git-manual-method 'woman
        magit-commit-show-diff nil)

  (defalias 'git       'magit-status)
  (defalias 'gitlog    'magit-log-buffer-file)

  (defun tvd-magit-cycle-down()
    "hide current section, jump down to the next and show it"
    (interactive)
    (magit-section-hide (magit-current-section))
    (magit-section-forward-sibling)
    (magit-section-show (magit-current-section)))

  (defun tvd-magit-cycle-up()
    "hide current section, jump up to the next and show it"
    (interactive)
    (magit-section-hide (magit-current-section))
    (magit-section-backward-sibling)
    (magit-section-show (magit-current-section)))

  ;; configure magit
  (with-eval-after-load 'magit
    (dolist (dir (list (expand-file-name "~/dev/D/github")
                       (expand-file-name "~/fits/git")
                       (expand-file-name "~/dev")))
      (when (file-exists-p dir)
        (add-to-list 'magit-repository-directories (cons dir 1))))
    (setq magit-completing-read-function 'magit-ido-completing-read)

    ;; use timestamps in log buffers
    (setq magit-log-margin '(t "%Y-%m-%d " magit-log-margin-width t 18))

    ;; navigate magit buffers as I do  in org-mode, that is going down
    ;; hides the current sibling, and vice versa
    (define-key magit-mode-map (kbd "<C-down>") 'tvd-magit-cycle-down)
    (define-key magit-mode-map (kbd "<C-up>")   'tvd-magit-cycle-up)
    (define-key magit-mode-map (kbd "<delete>") 'magit-delete-thing))

  ;; one thing though:  on startup it bitches about git  version, but it
  ;; works nevertheless. So I disable this specific warning.

  (defun tvd-ignore-magit-warnings-if-any ()
    (interactive)
    (when (get-buffer "*Warnings*")
      (with-current-buffer "*Warnings*"
        (goto-char (point-min))
        (when (re-search-forward "Magit requires Git >=")
          (kill-buffer-and-window)))))

  (add-hook 'after-init-hook 'tvd-ignore-magit-warnings-if-any t)

  ;; now, THIS is the pure genius me: hit "ls in magit-status buffer
  ;; and end up in a dired buffer of current repository. The default
  ;; binding for this is C-M-i, which is not memorizable, while "ls"
  ;; is. That is, 'l' is a prefix command leading to magit-log-popup
  ;; and 's' is undefined, which I define here, which then jumps to
  ;; dired.
  ;; see: https://github.com/magit/magit/wiki/Converting-popup-modifications-to-transient-modifications#adding-an-action
  (transient-append-suffix 'magit-log "l"
    '("s" "dired" magit-dired-jump))

  ;; after an exhausting discussion on magit#3139 I use this function
  ;; to (kind of) switch to another repository from inside magit-status.
  (defun tvd-switch-magit-repo ()
    (interactive)
    (let ((dir (magit-read-repository)))
      (magit-mode-bury-buffer)
      (magit-status dir)))
  (define-key magit-mode-map (kbd "C") 'tvd-switch-magit-repo)

  ;; via
  ;; http://manuel-uberti.github.io/emacs/2018/02/17/magit-bury-buffer/:
  ;; a great  enhancement, when closing  the magit status  buffer, ALL
  ;; other possibly  still remaining magit  buffers will be  killed as
  ;; well AND the window setup will be restored.
  (defun tvd-kill-magit-buffers()
    "Restore window setup from before magit and kill all magit buffers."
    (interactive)
    (let ((buffers (magit-mode-get-buffers)))
      (magit-restore-window-configuration)
      (mapc #'kill-buffer buffers)))

  (define-key magit-status-mode-map (kbd "q") #'tvd-kill-magit-buffers))


(use-package blamer
  ;; :bind (("s-i" . blamer-show-commit-info)
  ;;        ("C-c i" . ("s-i" . blamer-show-posframe-commit-info)))
  :defer 20
  :custom
  (blamer-idle-time 0.3)
  (blamer-min-offset 70)
  :custom-face
  (blamer-face ((t :foreground "#7a88cf"
                    :background nil
                    :height 140
                    :italic t)))
  :config
  (defalias 'blame 'blamer-mode))

(provide 'init-magit)
;;; init-magit.el ends here
