;; *** IDO mode

;; There are other completion  enhancement packages available like ivy
;; for example,  but I love IDO  and I am so  used to it, it  would be
;; impossible to  change. So, I'll  stick with  IDO until end  of (my)
;; times.

;; Hint: Use C-f during file selection to switch to regular find-file

;; Basic config
(ido-mode t)
(ido-everywhere nil)

(use-package ido-completing-read+)

(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point nil)
(setq ido-use-virtual-buffers t)
(setq ido-auto-merge-work-directories-length -1)

;; One thing annoys  me with IDO though: when writing  a new file, IDO
;; wants me  to select  from a  list of existing  files.  Since  it is
;; nearly impossible to disable ido mode for write-file, which I HATE,
;; I came up with this:

;; I added a  new global variable, 'tvd-ido-disabled, which  is nil by
;; default. Whenever I  hit C-x C-w (in order  to execute write-file),
;; it will be  set to t, ido mode will  be disabled and ido-write-file
;; will be called.  Since ido mode is now disabled,  it just calls the
;; original write-file, which is what I really want.

;; When I'm finished  selecting a filename and writing,  ido mode will
;; be turned  on again and the  variable will be set  to nil. However,
;; sometimes I may abort the process  using C-g. In that case ido mode
;; may end  up being disabled  because the  :after advice will  not be
;; called on C-g.

;; So,  I   also  advice  the   minibuffer  C-g  function,   which  is
;; 'abort-recursive-edit, and  re-enable ido mode  from here if  it is
;; still disabled. So far I haven't seen any bad side effects of this.

(defvar tvd-ido-disabled nil)
(advice-add 'ido-write-file :before '(lambda (&rest args) (ido-mode 0) (setq tvd-ido-disabled t)))
(advice-add 'ido-write-file :after  '(lambda (&rest args) (ido-mode 1) (setq tvd-ido-disabled nil)))

(defun tvd-keyboard-quit-advice (fn &rest args)
  (when tvd-ido-disabled
    (ido-mode 1)
    (setq tvd-ido-disabled nil))
  (apply fn args))

(advice-add 'abort-recursive-edit :around #'tvd-keyboard-quit-advice)

;; from emacs wiki
;; Display ido results vertically, rather than horizontally
(setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]"
                              " [No match]" " [Matched]" " [Not readable]"
                              " [Too big]" " [Confirm]")))

(defun ido-disable-line-truncation () (set (make-local-variable 'truncate-lines) nil))
(add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-truncation)
(defun ido-define-keys ()
  (define-key ido-completion-map (kbd "<down>") 'ido-next-match)
  (define-key ido-completion-map (kbd "<up>") 'ido-prev-match))
(add-hook 'ido-setup-hook 'ido-define-keys)

;; quickly go to home via ~ wherever I am
;; via [[http://whattheemacsd.com/setup-ido.el-02.html][whattheemacs.d]]
(add-hook 'ido-setup-hook
 (lambda ()
   ;; Go straight home
   (define-key ido-file-completion-map
     (kbd "~")
     (lambda ()
       (interactive)
       (if (looking-back "/")
           (insert "~/")
         (call-interactively 'self-insert-command))))
   ;; same thing, but for ssh/tramp triggered by :
   (define-key ido-file-completion-map
     (kbd ":")
     (lambda ()
       (interactive)
       (if (looking-back "/")
           (progn
             (ido-set-current-directory "/ssh:")
             (ido-reread-directory))
         (call-interactively 'self-insert-command))))))

;; by howardism: [re]open non-writable file with sudo
(defadvice ido-find-file (after find-file-sudo activate)
  "Find file as root if necessary."
  (unless (and buffer-file-name
               (file-writable-p buffer-file-name))
    (let* ((file-name (buffer-file-name))
           (file-root (if (string-match "/ssh:\\([^:]+\\):\\(.*\\)" file-name)
                          (concat "/ssh:"  (match-string 1 file-name)
                                  "|sudo:" (match-string 1 file-name)
                                  ":"      (match-string 2 file-name))
                        (concat "/sudo:localhost:" file-name))))
      (find-alternate-file file-root))))

;; FIXME: add ido-ignore-files defun.


(provide 'init-completion)
;;; init-completion.el ends here
