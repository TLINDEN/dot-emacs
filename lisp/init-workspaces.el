;; *** Eyebrowse Workspaces
;; workspace configuration, like desktops. Seems to be a good implementation, w/o save though

(use-package perspective
  :bind

  ;; global overrides
  (("C-x C-b" . persp-ibuffer)
   ("C-x b" . persp-switch-to-buffer*)
   ;; asks for confirmation
   ;; ("C-x k" . persp-kill-buffer*)
   )

  ;; perspective specifics
  (:map perspective-map
        ("C-x" . persp-switch-last)
        ("c" . tvd-persp-new)
        ("q" . persp-kill)
        ("C-k" . persp-kill)
        ("?" . hydra-persp/body))

  :custom
  (persp-mode-prefix-key (kbd "C-x C-x"))

  :init
  (persp-mode)

  :config
  (add-hook 'ibuffer-hook
            (lambda ()
              (persp-ibuffer-set-filter-groups)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic))))

  (defun tvd-persp-new(name)
    (interactive "sEnter new perspective name: ")
    (persp-new name)
    (persp-switch name))

  (when (fboundp 'defhydra)
             (defhydra hydra-persp (:color blue)
               "
^Persp Workspace Management^
^^--------------------------------------
_C-x_: last workspace   (C-x C-x C-x)
  _n_: next workspace   (C-x C-x <right>)
  _p_: prev workspace   (C-x C-x <left>)
  _q_: close workspace  (C-x C-x q) + (C-x C-x C-k)
  _r_: rename workspace (C-x C-x t)
  _c_: create workspace (C-x C-x n)

Use C-x C-x to access persp directly.
"
               ("C-x" persp-switch-last nil)
               ("n" persp-next nil)
               ("p" persp-prev nil)
               ("C-k" persp-kill nil)
               ("r" persp-rename nil)
               ("c" tvd-persp-new nil)
               ("q" nil nil :color red))))

(when nil
  (use-package eyebrowse
           :init
           ;; "prefix key" has to be set before loading, keep in mind, that
           ;; if you change it here, you need to change it below as well!
           (setq eyebrowse-keymap-prefix (kbd "C-x C-x"))
           (global-unset-key (kbd "C-x C-x"))

           :config
           (defun tvd-new-eyebrowse-workspace ()
             "Create new scratch buffer and ask for a name"
             (interactive)
             (eyebrowse-rename-window-config (eyebrowse--get 'current-slot) (read-string "Workspace: "))
             (autoscratch-buffer))

           ;; always enable
           (eyebrowse-mode t)

           (setq eyebrowse-new-workspace 'tvd-new-eyebrowse-workspace
                 eyebrowse-switch-back-and-forth t
                 eyebrowse-wrap-around t
                 eyebrowse-mode-line-style t
                 eyebrowse-slot-format "%s:init")

           ;; add a hydra, just in case, it contains hydra commands and hints
           ;; about the actual key bindings, it's also being refered from
           ;; hydra-window/body with "e"
           (when (fboundp 'defhydra)
             (defhydra hydra-eyebrowse (:color blue)
               "
^Eyebrowse Workspace Management^
^^--------------------------------------
_l_: last window      (C-x C-x C-x)
_n_: next window      (C-x C-x <right>)
_p_: prev window      (C-x C-x <left>)
_x_: close workspace  (C-x C-x q)
_t_: rename workspace (C-x C-x t)
_c_: create workspace (C-x C-x n)

Use C-x C-x to access eyebrowse directly.
"
               ("l" eyebrowse-last-window-config nil)
               ("n" eyebrowse-next-window-config nil)
               ("p" eyebrowse-prev-window-config nil)
               ("x" eyebrowse-close-window-config nil)
               ("t" eyebrowse-rename-window-config nil)
               ("c" eyebrowse-create-window-config nil)
               ("q" nil nil :color red)))

           ;;Modifying the eyebrowse keymap directly doesn't work because it's
           ;; not setup correctly. I sent a pull request to fix this:
           ;; https://github.com/wasamasa/eyebrowse/pull/94, however, vaslilly choosed
           ;; not to accept it. So, I need to configure the whole chords for every
           ;; function I use AND set the "prefix key" using the weird way above
           ;; (before loading).
           (global-set-key (kbd "C-x C-x C-x")     'eyebrowse-last-window-config)
           (global-set-key (kbd "C-x C-x <right>") 'eyebrowse-next-window-config)
           (global-set-key (kbd "C-x C-x <left>")  'eyebrowse-prev-window-config)
           (global-set-key (kbd "C-x C-x q")       'eyebrowse-close-window-config)
           (global-set-key (kbd "C-x C-x t")       'eyebrowse-rename-window-config)
           (global-set-key (kbd "C-x C-x n")       'eyebrowse-create-window-config)
           (global-set-key (kbd "C-x C-x ?")       'hydra-eyebrowse/body)))

;; There's also some face config, see defcustom at end of file!


(provide 'init-workspaces)
;;; init-workspaces.el ends here
