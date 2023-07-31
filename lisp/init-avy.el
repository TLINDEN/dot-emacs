;; see https://karthinks.com/software/avy-can-do-anything/

(use-package avy
  ;; use C-x C-SPC to jump back!
  :bind
  (;; global:
   ("C-j" . avy-goto-word-1)

   ;; mode specific:
   :map swiper-map
   ("C-j" . swiper-avy))

  :config

  (setq avy-style 'at-full)

  ;; Home row only (the default).
  (setq avy-keys '(?a ?s ?d ?f ?j ?k ?l))

  (setq avy-background t))


(provide 'init-avy)
;;; init-avy.el ends here
