;; *** Ediff Config

;; Force ediff to use  1 frame (the current) and not  open a new frame
;; for control  and help. Also  changing the split  orientation doesnt
;; open a new frame.

(eval-after-load "ediff"
  '(progn
     (setq ediff-diff-options   "-w"
           ediff-split-window-function 'split-window-horizontally
           ediff-window-setup-function 'ediff-setup-windows-plain)

     (add-hook 'ediff-startup-hook 'ediff-toggle-wide-display)
     (add-hook 'ediff-cleanup-hook 'ediff-toggle-wide-display)
     (add-hook 'ediff-suspend-hook 'ediff-toggle-wide-display)

     (add-hook 'ediff-mode-hook
               (lambda ()
                 (ediff-setup-keymap)
                 ;; merge left to right
                 (define-key ediff-mode-map ">" 'ediff-copy-A-to-B)
                 ;; merge right to left
                 (define-key ediff-mode-map "<" 'ediff-copy-B-to-A)))

     ;; restore window config on quit
     (add-hook 'ediff-after-quit-hook-internal 'winner-undo)
     ))

;; from emacswiki:
;; Usage: emacs -diff file1 file2
(defun command-line-diff (switch)
  (let ((file1 (pop command-line-args-left))
        (file2 (pop command-line-args-left)))
    (ediff file1 file2)))
(add-to-list 'command-switch-alist '("diff" . command-line-diff))



;; *** Smerge Config

;; smerge-mode is being issued during editing of conflicts from magit,
;; however, I  hate its default  prefix, but don't have  any practical
;; prefixes  left AND  am using  it far  too rare  to deserve  its own
;; prefix. So just a hydra will do.

(when (fboundp 'defhydra)
  (defhydra hydra-smerge (:color blue :timeout 30.0)
    "
^Smerge Mode^
^^-------------------------------------------------------
_n_ext conflict         keep _u_pper    m_e_rge conflicts in Ediff
_p_revious conflict     keep _l_ower    _q_uit"

    ("n"  smerge-next       nil :exit nil)
    ("p"  smerge-prev       nil :exit nil)
    ("u"  smerge-keep-upper nil :exit nil)
    ("l"  smerge-keep-lower nil :exit nil)
    ("e"  smerge-ediff      nil :color red)
    ("q"  nil               nil :color red))

  (defalias 'merge      'hydra-smerge/body))
