;; *** org mode

;; I use org mode to take notes  mostly at work. I also track projects
;; and  TODO  lists  etc.   I  do not,  however,  use  agenda  or  any
;; scheduling whatsoever.

;; I like custom bullets
(use-package org-bullets
  :config
  (setq org-bullets-bullet-list '("►" "✜" "✸" "✿" "♦")))

(use-package org
  :config


  ;; enable syntax highlighting for embedded source blocks
  (require 'ob-python)
  (require 'ob-perl)
  (require 'ob-shell)


  ;; capture target, os-dependend
  ;; FIXME: put this file outside emacs?
  (setq tvd-org-file (concat tvd-config-dir "/notizen.org")
        org-attach-directory (concat tvd-config-dir "/attachments"))

  ;; easier to open that way
  (defun notizen()
    (interactive)
    (switch-to-buffer (find-file tvd-org-file))
    (agenda))

  ;; text formatting made easy, bound to C-c keys locally
  (defun tvd-org-emphasize(CHAR)
    "expand once if no region and apply emphasize CHAR"
    (interactive)
    (unless (region-active-p)
      (er/expand-region 1))
    (org-emphasize CHAR))

  (defun bold()
    "bold text in org mode"
    (interactive)
    (tvd-org-emphasize '42))

  (defun italic()
    "italic text in org mode"
    (interactive)
    (tvd-org-emphasize '47))

  (defun code()
    "verbatim text in org mode"
    (interactive)
    (tvd-org-emphasize '126))

  (defun underline()
    "underline text in org mode"
    (interactive)
    (tvd-org-emphasize '95))

  ;; my org-mode specific <C-left> and <C-right>
  (defun tvd-org-left-or-level-up()
    "jump one word to the left if not on a org heading,
otherwise fold current level and jump one level up."
    (interactive)
    (if (and (org-at-heading-p) (looking-at "*"))
        (progn
          (hide-subtree)
          (outline-up-heading 1))
      (left-word)))

  (defun tvd-org-heading-up()
    "If on a heading, fold current heading, jump one level
up and unfold it, otherwise jump paragraph as usual."
    (interactive)
    (if (and (org-at-heading-p) (looking-at "*"))
        (progn
          (hide-subtree)
          (org-backward-heading-same-level 1)
          (org-cycle))
      (backward-paragraph)))

  (defun tvd-org-heading-down()
    "If on a heading, fold current heading, jump one level
down and unfold it, otherwise jump paragraph as usual."
    (interactive)
    (if (and (org-at-heading-p) (looking-at "*"))
        (progn
          (hide-subtree)
          (org-forward-heading-same-level 1)
          (org-cycle))
      (forward-paragraph)))

  ;; TODO: implement c-<left+right> to demote+promote again
  (defun tvd-org-demote-heading()
    "Demote heading if on a heading."
    (interactive)
    (if (org-at-heading-p)
        (org-demote-subtree)
      (call-interactively 'right-word)))

  (defun tvd-org-promote-heading()
    "Promote heading if on a heading."
    (interactive)
    (if (org-at-heading-p)
        (org-promote-subtree)
      (call-interactively 'left-word)))

  ;; org-mode specific config, after load
  (eval-after-load "org"
    '(progn
       (add-hook 'org-mode-hook
                 (lambda ()
                   (setq
                    org-M-RET-may-split-line nil
                    org-agenda-files (list tvd-org-file)
                    org-agenda-restore-windows-after-quit t
                    org-blank-before-new-entry (quote ((heading . auto) (plain-list-item . auto)))
                    org-catch-invisible-edits (quote error)
                    org-columns-default-format "%80ITEM %22Timestamp %TODO %TAGS %0PRIORITY"
                    org-insert-heading-always-after-current (quote t)
                    org-mouse-1-follows-link nil
                    org-remember-store-without-prompt t
                    org-reverse-note-order t
                    org-startup-indented t
                    org-startup-truncated nil
                    org-return-follows-link t
                    org-use-speed-commands t
                    org-yank-adjusted-subtrees t
                    org-refile-targets '((nil . (:maxlevel . 5)))
                    org-refile-use-outline-path t
                    org-outline-path-complete-in-steps nil
                    org-completion-use-ido t
                    org-support-shift-select t
                    org-hide-emphasis-markers t
                    org-fontify-done-headline t
                    org-pretty-entities t
                    org-use-sub-superscripts nil
                    org-confirm-babel-evaluate nil)
                                        ; shortcuts
                   (setq org-speed-commands-user
                         (quote (
                                 ("0" . ignore)
                                 ("1" . delete-other-windows)
                                 ("2" . ignore)
                                 ("3" . ignore)
                                 ("d" . org-archive-subtree-default-with-confirmation) ; delete, keep track
                                 ("v" . org-narrow-to-subtree) ; only show current heading ("view")
                                 ("q" . widen)                 ; close current heading and show all ("quit")
                                 (":" . org-set-tags-command)  ; add/edit tags
                                 ("t" . org-todo)              ; toggle todo type, same as C-t
                                 ("z" . org-refile)            ; archive the (sub-)tree
                                 ("a" . org-attach)            ; manage attachments
                                 )))
                                        ; same as toggle
                   (local-set-key (kbd "C-t") 'org-todo)

                                        ; alt-enter = insert new subheading below current
                   (local-set-key (kbd "<M-return>") 'org-insert-subheading)

                                        ; search for tags (ends up in agenda view)
                   (local-set-key (kbd "C-f") 'org-tags-view)

                                        ; run presenter, org-present must be installed and loadedwhite
                   (local-set-key (kbd "C-p") 'org-present)

                                        ; todo colors
                   (setq org-todo-keyword-faces '(
                                                  ("TODO"   . (:foreground "deepskyblue" :weight bold))
                                                  ("START"  . (:foreground "olivedrab"   :weight bold))
                                                  ("WAIT"   . (:foreground "darkorange"  :weight bold))
                                                  ("DONE"   . (:foreground "forestgreen" :weight bold))
                                                  ("CANCEL" . (:foreground "darkorchid"  :weight bold))
                                                  ("FAIL"   . (:foreground "red"         :weight bold))
                                                  ))

                   (local-set-key (kbd "C-c b") 'bold)
                   (local-set-key (kbd "C-c /") 'italic)
                   (local-set-key (kbd "C-c 0") 'code) ; aka = without shift
                   (local-set-key (kbd "C-c _") 'underline)

                                        ; edit babel src block in extra buffer:
                                        ; default is C-c ' which is hard to type
                                        ; brings me to src code editor buffer
                                        ; Also note: enter <s then TAB inserts a code block
                                        ; Next, C-c C-c executes the code, adding :results table at the
                                        ; end of the begin line, creates a table of the output
                   (local-set-key (kbd "C-c C-#") 'org-edit-special)

                   ;; faster jumping
                   (local-set-key (kbd "<C-up>")   'tvd-org-heading-up)
                   (local-set-key (kbd "<C-down>") 'tvd-org-heading-down)

                   ;; move word left or heading up, depending where point is
                   (local-set-key (kbd "<C-right>") 'tvd-org-demote-heading)
                   (local-set-key (kbd "<C-left>") 'tvd-org-promote-heading)

                   ;; use nicer bullets
                   (when (fboundp 'org-bullets-mode)
                     (org-bullets-mode 1))

                   (org-babel-do-load-languages 'org-babel-load-languages
                                                '((python     . t)
                                                  (emacs-lisp . t)
                                                  (shell      . t)
                                                  (perl       . t)))))))

  ;; no more ... at the end of a heading
  (setq org-ellipsis " ⤵")

  ;; my own keywords, must be set globally, not catched correctly inside hook
  (setq org-todo-keywords
        '((sequence "TODO" "START" "WAIT" "|" "DONE" "CANCEL" "FAIL")))

  ;; I always want to be able to capture, even if no ORG is running
  (global-set-key (kbd "C-n")             (lambda () (interactive) (org-capture)))

  ;; must be global since code edit sub buffers run their own major mode, not org
  (global-set-key (kbd "C-c C-#")         'org-edit-src-exit)

  ;; some org mode vars must be set globally
  (setq org-default-notes-file tvd-org-file
        org-startup-indented t
        org-indent-indentation-per-level 4)

  ;; my own capture templates
  (setq org-capture-templates
        '(("n" "Project" entry (file+headline tvd-org-file "Unsorted Tasks")
           "* TODO %^{title}\n%u\n** Kostenstelle\n** Contact Peer\n** Contact Customer\n** Aufträge\n** Daten\n** Notizen\n  %i%?\n"
           :prepend t :jump-to-captured t)

          ("t" "Todo Item" entry (file+headline tvd-org-file "Manual-Agenda-Tasks")
           "* TODO %^{title}\n:LOGBOOK:\n%u:END:\n" :prepend t :immediate-finish t)

          ("s" "Scheduled Item" entry (file+headline tvd-org-file "Scheduled-Agenda-Tasks")
           "* TODO %^t %^{title}\n:LOGBOOK:\n%u:END:\n" :prepend t :immediate-finish t)

          ("j" "Journal" entry (file+headline tvd-org-file "Kurznotizen")
           "* TODO %^{title}\n%u\n  %i%?\n" :prepend t :jump-to-captured t)

          ("c" "Copy/Paste" entry (file+headline tvd-org-file "Kurznotizen")
           "* TODO %^{title}\n%u\n  %x\n" :immediate-finish t :prepend t :jump-to-captured t)))

  ;; follow links using eww, if present
  ;; (if (fboundp 'eww-browse-url)
  ;;     (setq browse-url-browser-function 'eww-browse-url))

  ;; mark narrowing with an orange fringe, the advice for 'widen
  ;; is in the outline section.
  (advice-add 'org-narrow-to-subtree :after
              '(lambda (&rest args)
                 (set-face-attribute 'fringe nil :background tvd-fringe-narrow-bg)))

  ;; I hate fundamental mode!
  (setq default-major-mode 'org-mode))


(provide 'init-org)
;;; init-org.el ends here
