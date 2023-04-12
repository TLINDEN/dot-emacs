;; *** MMM Mode
(use-package mmm-mode
             :config
             (require 'cl-lib)
             (require 'mmm-auto)
             (require 'mmm-vars)

             (setq mmm-submode-decoration-level 2)

             ;; [[https://github.com/purcell/mmm-mode][mmm-mode github]]
             ;; see doc for class definition in var 'mmm-classes-alist
             ;; **** MMM config for POD mode
             (mmm-add-classes
              '((html-pod
                 :submode html-mode ;; web-mode doesnt work this way!
                 :delimiter-mode nil
                 :front "=begin html"
                 :back "=end html")))

             (mmm-add-mode-ext-class 'pod-mode nil 'html-pod)

             :hook (pod-mode mmm-mode-on))
