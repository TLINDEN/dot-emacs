;;; *** highlight todo keywords (such as FIXME)

;; Absolutely needed!

(use-package fic-mode
          :config
          (add-something-to-mode-hooks '(c c++ cperl vala web emacs-lisp ruby python yaml) 'fic-mode))


;;; *** UNDO Tree Mode

;; Better undo, with redo support.

;; C-_   (`undo-tree-undo')
;;   Undo changes.
;;
;; C-:   (`undo-tree-redo')
;;   Redo changes.
;;
;; more: see undo-tree.el
(use-package undo-tree
             :config

             ;; use always
             (global-undo-tree-mode)

             ;; M-_ catched by Xmonad
             (global-set-key (kbd "C-:")             'undo-tree-redo))                                  ; C-: == REDO   C-_ == UNDO



;;; *** Smarter M-x Mode (smex)

;; This is really cool and I don't know how I could ever live without it.
(use-package smex
             :config
             (smex-initialize)
             (global-set-key (kbd "M-x") 'smex)
             (global-set-key (kbd "M-X") 'smex-major-mode-commands))



;;; *** Smarter Search

;; test, replace isearch-forward-regexp first only.
;; dir: ivy/
(use-package swiper
             :config
             (setq ivy-wrap t)
             (global-set-key "\C-s" 'swiper))



;;; *** Which Func
;; display current function - if any - in mode line
(add-something-to-mode-hooks
    '(c c++ cperl vala makefile ruby shell-script python go)
    'which-func-mode)



;;; *** Show current-line in the Fringe
(use-package fringe-current-line
             :config
             (global-fringe-current-line-mode 1)

             ;; also change the color (matching the mode line
             ;; (set-face-attribute 'fringe nil :foreground "NavyBlue")
             )



;;; *** Save cursor position

;; So the  next time  I start  emacs and  open a  file I  were editing
;; previously,  (point) will  be  in  the exact  places  where it  was
;; before.
(save-place-mode 1)



;;; *** Hightligt TABs

;; not a mode, but however: higlight TABs in certain modes

(defface extra-whitespace-face
  '((t (:background "pale green")))
  "Used for tabs and such.")

(defvar tvd-extra-keywords
  '(("\t" . 'extra-whitespace-face)))

(add-something-to-mode-hooks '(c c++ vala cperl emacs-lisp python shell-script ruby)
                             (lambda () (font-lock-add-keywords nil tvd-extra-keywords)))


;;; *** Browse kill-ring

;; when active use n  and p to browse, <ret> to  select, it's the same
;; as <M-y> and I never really use it...

(use-package browse-kill-ring
             :config
             (setq browse-kill-ring-highlight-current-entry t
                   browse-kill-ring-highlight-inserted-item t))


;;; *** goto-last-change

;; Very handy, jump to last change[s].

(use-package goto-last-change
             :config
             (global-set-key (kbd "C-b")             'goto-last-change))



;;; *** Bookmarks

;; I use  the builtin bookmark feature  quite a lot and  am happy with
;; it.  Especially at  work, where  many  files are  located in  large
;; path's on remote storage systems, it  great to jump quickly to such
;; places.

;; everytime bookmark is changed, automatically save it
(setq bookmark-save-flag 1
      bookmark-version-control t)

;; I use the same aliases as in apparix for bash (since I'm used to them)
(defalias 'to        'bookmark-jump)
(defalias 'bm        'bookmark-set)
(defalias 'bl        'bookmark-bmenu-list)



;;; *** which-key

;; One of the  best unobstrusive modes for key help  ever.  Just start
;; entering  a key  chord, prefix  or whatever,  and it  pops a  small
;; buffer (on the right side in my case) showing the avialable keys to
;; press from there along with the associated functions.

(use-package which-key
             :config
             (which-key-mode)
             (which-key-setup-side-window-right))



;;; *** Beacon mode (pointer blink)
;; Source: [[https://github.com/Malabarba/beacon][beacon mode]]

;; Blink the cursor shortly when  moving across large text sections or
;; when changing  windows. That way it  is easier to find  the current
;; editing position.

(use-package beacon
             :config

             (setq beacon-blink-duration 0.1
                   beacon-blink-when-point-moves-vertically 10
                   beacon-color 0.3)

             (add-hook 'beacon-dont-blink-predicates
                       (lambda () (bound-and-true-p novel-mode)))

             (beacon-mode))



;;; other aliases
;; show available colors:
(defalias 'colors 'list-colors-display)


(provide 'init-ui)
;;; init-ui.el ends here
