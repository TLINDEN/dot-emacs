;; *** Projectile
(use-package projectile
  :defer nil

  :init
  (global-unset-key (kbd "C-p"))

  :bind (:map projectile-mode-map
              ("C-p" . projectile-command-map))

  :config
  (projectile-mode +1)

  (defun tvd-dir-to-projectile ()
    "drop a .projectile wherever we are"
    (interactive)
    (with-temp-file ".projectile"
      (insert "-.snapshot\n-.git\n-.RCS\n"))
    (message (format "Turned %s into projectile project" default-directory)))

  (setq projectile-project-search-path '("~/fits/jobs/" "~/.fits/")
        projectile-auto-discover t)

  (projectile-register-project-type 'fitsjob '("README")
                                    :project-file '("README?*" "?*.org" "instances"))

  ;; FIXME: add custom docstring
  (when (fboundp 'defhydra)
    (defhydra hydra-projectile
      ( :color teal
        :columns 4)
      "Projectile (use C-x p for this menu)"
      ("s"   projectile-switch-project           "Switch Project")
      ("f"   projectile-find-file                "Find File")
      ("r"   projectile-recentf                  "Recent Files")
      ("b"   projectile-ibuffer                  "Show Project Buffers")

      ("g"   projectile-grep                     "Grep")
      ("o"   projectile-multi-occur              "Multi Occur")
      ("d"   projectile-dired                    "Project Dired")
      ("R"   projectile-replace                  "Replace in Project")

      ("C"   projectile-invalidate-cache         "Clear Cache")
      ("t"   projectile-regenerate-tags          "Regenerate Tags")
      ("X"   projectile-cleanup-known-projects   "Cleanup Known Projects")
      ("n"   tvd-dir-to-projectile               "Turn current directory into Projectile")

      ("c"   projectile-commander                "Commander")
      ("k"   projectile-kill-buffers             "Kill Buffers")
      ("q"   nil                                 "Cancel" :color blue))

    (global-set-key (kbd "C-x p") 'hydra-projectile/body)))


(provide 'init-projectile)
;;; init-projectile.el ends here
