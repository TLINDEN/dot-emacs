;; *** Tabulated List Mode
;; built-in, used by many interactive major modes

 (defun tvd-close-window ()
               (interactive)
               (kill-this-buffer)
               (delete-window))

;; +tablist, which provides many cool features
;; [[https://github.com/politza/tablist][github source]]
;; important commands:
;; - <  shrink column
;; - >  enlarge column
;; - s  sort column
;; - /  prefix for filter commands
;;   / e   edit filter, e.g. do not list auto-complete sub-packages in melpa:
;;   / a  ! Package =~ ac- <ret>
(use-package tablist
             :ensure t

             :config

             ;; we need to kill tablist's binding in order to have ours run (see below)
             (define-key tablist-minor-mode-map (kbd "q") nil)
             (define-key tablist-minor-mode-map (kbd "q") 'tvd-close-window)

             (eval-after-load "tabulated-list"
               '(progn
                  (add-hook 'tabulated-list-mode-hook
                            (lambda ()
                              (tablist-minor-mode)
                              (local-set-key (kbd "Q") 'delete-other-windows)
                              (hl-line-mode))))))
