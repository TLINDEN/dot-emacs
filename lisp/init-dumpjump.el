;; *** Dumpjump
;; https://github.com/jacktasia/dumb-jump/raw/master/dumb-jump.el
(use-package dumb-jump
             :config

             (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
             (setq xref-show-definitions-function #'xref-show-definitions-completing-read)

             (setq dumb-jump-quiet t)

             (when (fboundp 'defhydra)
               (defhydra hydra-dumb-jump (:color blue :columns 3)
                 "Dumb Jump"
                 ("j" dumb-jump-go "Go")
                 ("o" dumb-jump-go-other-window "Other window")
                 ("e" dumb-jump-go-prefer-external "Go external")
                 ("x" dumb-jump-go-prefer-external-other-window "Go external other window")
                 ("i" dumb-jump-go-prompt "Prompt")
                 ("l" dumb-jump-quick-look "Quick look")
                 ("b" dumb-jump-back "Back"))

               (global-set-key (kbd "C-x j") 'hydra-dumb-jump/body))
             (global-set-key (kbd "C-c j") 'dumb-jump-go)
             (global-set-key (kbd "C-c b") 'dumb-jump-back))

;; TODO: look at https://github.com/jojojames/smart-jump, maybe better?

(provide 'init-dumpjump)
;;; init-dumpjump.el ends here
