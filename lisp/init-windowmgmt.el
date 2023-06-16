;; NOTDONE
;;; ** WINDOW management stuff
;; *** resize windows by keyboard

;; Very practical: resize windows easily.

;; hit C-c C-r then use cursor keys to resize, <ret> to finish
(use-package windresize
             :config
             (global-set-key (kbd "C-c C-r")         'windresize))

;; *** switch windows with MS-WINDOWS key
(use-package windmove
             :ensure nil
             :config
             (windmove-default-keybindings 'super)
             (setq windmove-wrap-around t))

;; *** M-o switch window or buffer

;; The key M-o has different functions depending on context:
;;
;; If there's only 1 window open, switch to the last active.
;;
;; If there  are 2  windows open,  switch back  and forth  between the
;; two. In order to flip them, Use M-O (that is: ALT+shift+o).
;;
;; And if  there are more than  2 windows open, call  the hydra, which
;; allows to switch to another window  using the arrow keys. The hydra
;; stays for 1 second  unles an arrow key has been  pressed. So, I can
;; press  multiple arrow  keys in  a row  as long  as I'm  fast enough
;; between key  presses. If I stop,the  hydra disappears and I  end up
;; whereever I was last.
;;
;; Also, within the hydra 'o' jumps  to the last active window and
;; 'f' flips all windows.

;; from https://github.com/lukhas/buffer-move
(use-package buffer-move)

(defun tvd-previous-window (&optional ignore)
  "Toggle between the last two selected windows."
  (interactive)
  (let ((win (get-mru-window t t t)))
    (unless win (error "Last window not found."))
    (select-window win)))

;; via
;; [[http://whattheemacsd.com/buffer-defuns.el-02.html][whattheemacs.d]]:
;; exchange left with right buffer (or up and down), love it.
(defun tvd-flip-windows ()
  "Rotate your windows"
  (interactive)
  (cond ((not (> (count-windows)1))
         (message "You can't rotate a single window!"))
        (t
         (setq i 1)
         (setq numWindows (count-windows))
         (while  (< i numWindows)
           (let* (
                  (w1 (elt (window-list) i))
                  (w2 (elt (window-list) (+ (% i numWindows) 1)))
                  (b1 (window-buffer w1))
                  (b2 (window-buffer w2))
                  (s1 (window-start w1))
                  (s2 (window-start w2))
                  )
             (set-window-buffer w1  b2)
             (set-window-buffer w2 b1)
             (set-window-start w1 s2)
             (set-window-start w2 s1)
             (setq i (1+ i)))))))

(when (and (fboundp 'windmove-up) (fboundp 'buf-move-up) (fboundp 'defhydra))
  (defhydra hydra-switch-windows (:color pink: :timeout 2.5)
    "
Switch to buffer: ← ↑ → ↓   | _o_: previous | _f_: flip | MOVE: _u_: up    _d_: down   _l_: left   _r_: right   _M-o_: cycle"
    ("<up>"    windmove-up    nil)
    ("<down>"  windmove-down  nil)
    ("<left>"  windmove-left  nil)
    ("<right>" windmove-right nil)
    ("o"       tvd-previous-window nil :color blue)
    ("f"       tvd-flip-windows    nil :color blue)
    ("u"       buf-move-up         nil :color blue)
    ("d"       buf-move-down       nil :color blue)
    ("l"       buf-move-left       nil :color blue)
    ("r"       buf-move-right      nil :color blue)
    ("M-o"     other-window        nil :color blue)
    ("q" nil nil :color red))

  ;; via [[http://mbork.pl/2017-02-26_other-window-or-switch-buffer][mbork]]
  ;; modified to call the above hydra if there are more than 2 windows
  (defun other-window-or-switch-buffer ()
    "Call `other-window' if more than one window is visible, switch
to next buffer otherwise."
    (interactive)
    (if (one-window-p)
        (switch-to-buffer nil)
      (progn
        (if (= (length (window-list)) 2)
            (other-window 1)
          (hydra-switch-windows/body)))))

  (global-set-key (kbd "M-o")             'other-window-or-switch-buffer)

  ;; M-o doesn't  work when using emacs  via Win->RDP->VNC->X11->Xmonad,
  ;; so fall back to C-o.
  ;; I'm not using windows anymore
  ;; (global-set-key (kbd "C-o")             'other-window-or-switch-buffer)

  ;; Use only in  X11 emacs - setting M-O inside console  causes <up> and
  ;; <down> to stop working properly, for whatever reasons.
  (if (display-graphic-p)
      (global-set-key (kbd "M-O")             'tvd-flip-windows)))

;; --------------------------------------------------------------------------------
;; *** Split window to 4 parts

(defun tvd-quarter-windows ()
  (interactive)
  (split-window-vertically)
  (split-window-horizontally)
  (windmove-down)
  (split-window-horizontally))

(global-set-key (kbd "C-x 4")           'tvd-quarter-windows)

;; --------------------------------------------------------------------------------

;; *** Remember and Restore Window Configurations - winner mode

(winner-mode 1)

;; keybindings: C-c left    - winner-undo
;; keybindings: C-c right   - winner-redo


;; *** Window Hydra

;; brightness wrappers
(defun tvd-bg-brighter ()
  (interactive)
  (doremi-increment-background-color-1 ?v -1))

(defun tvd-bg-darker ()
  (interactive)
  (doremi-increment-background-color-1 ?v 1))

(defun tvd-pre-resize ()
  "Called as  pre execute  hook py  hydra-windows-resize/body and
executes the called key once, so that no key press gets lost from
hydra-windows (a,s,d,w)"
  (interactive)
  (let
      ((key (car (reverse (append (recent-keys) nil)))))
    (cond
     ((eq key ?a)
      (shrink-window-horizontally 1))
     ((eq key ?d)
      (enlarge-window-horizontally 1))
     ((eq key ?w)
      (shrink-window 1))
     ((eq key ?s)
      (enlarge-window 1)))))

(when (fboundp 'defhydra)
  (defhydra hydra-windows-resize (:color pink :pre (tvd-pre-resize))
    ;; small sub hydra  for window resizing, it leaves as  much room for
    ;; windows as possible
    "
_a_ ||    _d_ |---|     _w_ ---   _s_ ="
    ("a" shrink-window-horizontally nil)
    ("d" enlarge-window-horizontally nil)
    ("w" shrink-window nil)
    ("s" enlarge-window nil)
    ("q" nil nil :color red))

  (defhydra hydra-windows (:color blue)
    "

^Window Management^
^^------------------------------------------------------------------------
_+_ Increase Font | _-_ Decrease Font      Resize     ^ ^  _w_  ^ ^
_f_: Flip Windows    <M-O>            ^^   Current    _a_  ^ ^  _d_
_4_: Quarter Windows <C-x 4>          ^^   Window:    ^ ^  _s_  ^ ^
_u_: Windows Undo    <C-c left>
_r_: Windows Redo    <C-c right>      ^^   _l_: Adjust Background brighter
_i_: Invert Colors   <C-c C-i>        ^^   _b_: Adjust Background darker

_h_: Toggle Highlight Line Mode       ^^   _e_: Eyebrowse Workspaces (C-x C-x)
_n_: Toogle Line Number Mode

^^------------------------------------------------------------------------
Reach this hydra with <C-x w>
^^------------------------------------------------------------------------

"
    ("+" tvd-global-font-size-bigger nil :color pink)
    ("-" tvd-global-font-size-smaller nil :color pink)
    ("f" tvd-flip-windows nil)
    ("4" tvd-quarter-windows nil)
    ("u" winner-undo nil)
    ("r" winner-redo nil)
    ("i" tvd-invert nil)
    ("b" tvd-bg-darker nil :color pink)
    ("l" tvd-bg-brighter nil :color pink)
    ("a" hydra-windows-resize/body nil)
    ("d" hydra-windows-resize/body nil)
    ("w" hydra-windows-resize/body nil)
    ("s" hydra-windows-resize/body nil)
    ("e" hydra-eyebrowse/body nil)
    ("h" hl-line-mode nil)
    ("n" linum-mode nil)
    ("q" nil nil :color red))

  (global-set-key (kbd "C-x w") 'hydra-windows/body))


;; configure emacs window behavior
;; see also https://www.masteringemacs.org/article/demystifying-emacs-window-manager
(customize-set-variable 'display-buffer-base-action
  '((display-buffer-reuse-window display-buffer-same-window)
    (reusable-frames . t)))

(customize-set-variable 'even-window-sizes nil)     ; avoid resizing


(provide 'init-windowmgmt)
;;; init-windowmgmt.el ends here
