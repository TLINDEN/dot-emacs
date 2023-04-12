;; *** iBuffer mode

;; iBuffer is a great interactive buffer management tool included with
;; emacs.   I  use  it  with  a   couple  of  custom  groups,  my  own
;; collapse-code (<TAB>) and formats.

(require 'ibuffer)

;; from github:
(use-package ibuffer-vc)
(use-package ibuffer-tramp)

;; replace default list-buffers with ibuffer
(global-set-key (kbd "C-x C-b")         'ibuffer)

;; group name
(setq tvd-ibuffer-filter-group-name "tvd-filters")

;; filter group config
;; with hints from [[https://ogbe.net/emacsconfig.html][Ogbe]] et.al.
(setq ibuffer-saved-filter-groups
      (list (nreverse
             `(
               ("Org" (mode . org-mode))
               ("Shell" (or (mode . term-mode)
                            (mode . eshell-mode)
                            (mode . shell-mode)))
               ("Emacs-Config"  (filename . "emacs"))
               ("Cisco-Config" (mode . cisco-mode))
               ("Code" (or (mode . cperl-mode)
                           (mode . c-mode)
                           (mode . python-mode)
                           (mode . shell-script-mode)
                           (mode . makefile-mode)
                           (mode . cc-mode)))
               ("Text" (or (mode . text-mode)
                           (filename . "\\.pod$")))
               ("LaTeX" (mode . latex-mode))
               ("Interactive" (or
                               (mode . inferior-python-mode)
                               (mode . slime-repl-mode)
                               (mode . inferior-lisp-mode)
                               (mode . inferior-scheme-mode)
                               (name . "*ielm*")))
               ("Crab" (or
                        (name . "^\\*\\(Help\\|scratch\\|Messages\\)\\*")
                          ))
               ,tvd-ibuffer-filter-group-name))))

;; Reverse the  order of the  filter groups. Kind of  confusing: Since
;; I'm reversing the  order of the groups above,  this snippet ensures
;; that the groups are ordered in the way they are written above, with
;; the "Default" group on top. This  advice might need to be ported to
;; the new advice system soon.

(defadvice ibuffer-generate-filter-groups
    (after reverse-ibuffer-groups () activate)
  (setq ad-return-value (nreverse ad-return-value)))

(defun ibuffer-add-dynamic-filter-groups ()
  (interactive)
  (dolist (group (ibuffer-vc-generate-filter-groups-by-vc-root))
    (add-to-list 'ibuffer-filter-groups group))
  (dolist (group (ibuffer-tramp-generate-filter-groups-by-tramp-connection))
    (add-to-list 'ibuffer-filter-groups group)))

(defun tvd-ibuffer-hooks ()
  (ibuffer-auto-mode 1)
  (ibuffer-switch-to-saved-filter-groups tvd-ibuffer-filter-group-name)
  (ibuffer-add-dynamic-filter-groups)
  (ibuffer-vc-set-filter-groups-by-vc-root)
  )
(add-hook 'ibuffer-mode-hook 'tvd-ibuffer-hooks)

;; Only show groups that have active buffers
(setq ibuffer-show-empty-filter-groups nil)

;; Don't show the summary or headline
(setq ibuffer-display-summary nil)

;; do not prompt for every action
(setq ibuffer-expert t)

;; buffers to always ignore
(add-to-list 'ibuffer-never-show-predicates "^\\*\\(Completions\\|tramp/\\)")

;; Use human readable Size column instead of original one
(define-ibuffer-column size-h
  (:name "Size" :inline t)
  (cond
   ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1000000.0)))
   ((> (buffer-size) 100000) (format "%7.0fk" (/ (buffer-size) 1000.0)))
   ((> (buffer-size) 1000) (format "%7.1fk" (/ (buffer-size) 1000.0)))
   (t (format "%8d" (buffer-size)))))

;; Modify the default ibuffer-formats
(setq ibuffer-formats
      '((mark modified read-only " "
              (name 20 40 :left :elide)
              " "
              (size-h 9 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " "
              (vc-status 16 16 :left)
              " "
              filename-and-process)))

;; hide annoying groups, but keep its buffers available
(defvar ibuffer-collapsed-groups (list "Crab"))

(advice-add 'ibuffer :after '(lambda (&rest args)
  (ignore args)
  (save-excursion
    (dolist (group ibuffer-collapsed-groups)
      (ignore-errors
        (ibuffer-jump-to-filter-group group)
        (ibuffer-toggle-filter-group))))))

;; move point to most recent buffer when entering ibuffer
(defadvice ibuffer (around ibuffer-point-to-most-recent) ()
           "Open ibuffer with cursor pointed to most recent (non-minibuffer) buffer name"
           (let ((recent-buffer-name
                  (if (minibufferp (buffer-name))
                      (buffer-name
                       (window-buffer (minibuffer-selected-window)))
                    (buffer-name (other-buffer)))))
             ad-do-it
             (ibuffer-jump-to-buffer recent-buffer-name)))
(ad-activate 'ibuffer)

;; override ibuffer M-o binding
(define-key ibuffer-mode-map (kbd "M-o")    'other-window-or-switch-buffer)

