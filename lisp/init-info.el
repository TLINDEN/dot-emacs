;; *** INFO Mode

(require 'info)

;; open an info file somewhere outside %infodir% with info-mode
(defun info-find-file (file)
  (interactive "f")
  (info-setup file
              (pop-to-buffer-same-window
               (format "*info*<%s>"
                       (file-name-sans-extension
                        (file-name-nondirectory file))))))

;; easier navigation in Info mode, intuitive history back and forth.
(eval-after-load "Info"
  '(progn
     (define-key Info-mode-map (kbd "<C-left>")  'Info-history-back)
     (define-key Info-mode-map (kbd "<C-right>") 'Info-history-forward)
     (use-package info+
                  :ensure nil)))

;; make Info great again!
;; [[http://mbork.pl/2014-12-27_Info_dispatch][based on Marcins]] info dispatch,
;; contains (interactive) code from 'info-display-manual for manual selection.
(defun i (manual)
    "Read documentation for MANUAL in the info system.  Name the
buffer '*Info MANUAL*'.  If that buffer is already present, just
switch to it.

If MANUAL not given as argument, ask interactively with completion
to select from a list of installed manuals."
  (interactive
   (list
    (progn
      (info-initialize)
      (ido-completing-read "Manual name: "
                       (info--manual-names current-prefix-arg)
                       nil t))))
  (let ((buffer (format "*Info %s*" manual)))
    (if (get-buffer buffer)
      (switch-to-buffer bufer)
      (info manual buffer))))

;; from examples, I love this one!, replaces the ? buffer
(define-key Info-mode-map (kbd "?") #'hydra-info/body)
(defhydra hydra-info (:color blue
                      :hint nil)
      "
Info-mode:
  ^^_]_ forward  (next logical node)       ^^_l_ast (←)        _u_p (↑)                             _f_ollow reference       _T_OC
  ^^_[_ backward (prev logical node)       ^^_r_eturn (→)      _m_enu (↓) (C-u for new window)      _i_ndex                  _d_irectory
  ^^_n_ext (same level only)               ^^_H_istory         _g_oto (C-u for new window)          _,_ next index item      _c_opy node name
  ^^_p_rev (same level only)               _<_/_t_op           _b_eginning of buffer                virtual _I_ndex          _C_lone buffer
  regex _s_earch (_S_ case sensitive)      ^^_>_ final         _e_nd of buffer                      ^^                       _a_propos

  _1_ .. _9_ Pick first .. ninth item in the node's menu.

"
      ("]"   Info-forward-node nil)
      ("["   Info-backward-node nil)
      ("n"   Info-next nil)
      ("p"   Info-prev nil)
      ("s"   Info-search nil)
      ("S"   Info-search-case-sensitively nil)

      ("l"   Info-history-back nil)
      ("r"   Info-history-forward nil)
      ("H"   Info-history nil)
      ("t"   Info-top-node nil)
      ("<"   Info-top-node nil)
      (">"   Info-final-node nil)

      ("u"   Info-up nil)
      ("^"   Info-up nil)
      ("m"   Info-menu nil)
      ("g"   Info-goto-node nil)
      ("b"   beginning-of-buffer nil)
      ("e"   end-of-buffer nil)

      ("f"   Info-follow-reference nil)
      ("i"   Info-index nil)
      (","   Info-index-next nil)
      ("I"   Info-virtual-index nil)

      ("T"   Info-toc nil)
      ("d"   Info-directory nil)
      ("c"   Info-copy-current-node-name nil)
      ("C"   clone-buffer nil)
      ("a"   info-apropos nil)

      ("1"   Info-nth-menu-item nil)
      ("2"   Info-nth-menu-item nil)
      ("3"   Info-nth-menu-item nil)
      ("4"   Info-nth-menu-item nil)
      ("5"   Info-nth-menu-item nil)
      ("6"   Info-nth-menu-item nil)
      ("7"   Info-nth-menu-item nil)
      ("8"   Info-nth-menu-item nil)
      ("9"   Info-nth-menu-item nil)

      ("?"   Info-summary "Info summary")
      ("h"   Info-help "Info help")
      ("q"   Info-exit "Info exit")
      ("C-g" nil "cancel" :color blue))



(provide 'init-info)
;;; init-info.el ends here
