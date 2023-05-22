;;; *** Recent Files

;; You know the  file you edited yesterday had "kri"  in its name, but
;; where was it? You don't remember.  But don't worry, recent files is
;; your friend.  It shows the last  N files you edited  recently.
;; I use it permanently.

;; see also: ido-mode and smex

(defun tvd-buffer-exists-p (bufname)
  (not (eq nil (get-file-buffer bufname))))

;; setup
(use-package recentf
             :config
             (require 'cl-lib)
             (setq recentf-auto-cleanup 'never) ;; avoid stat() on tramp buffers
             (recentf-mode 1)

             ;; I like to have a longer list reaching deeper into the past
             (setq recentf-max-menu-items 200
                   recentf-max-saved-items nil)

             ;; enable IDO completion
             ;; via [[http://emacsredux.com/blog/2013/04/05/recently-visited-files/][emacsredux]]
             ;; modified to exclude already visited files
             (defun recentf-ido-find-file ()
               "Find a recent file using ido."
               (interactive)
               (let ((file (ido-completing-read
                            "Choose recent file: "
                            (cl-remove-if 'tvd-buffer-exists-p recentf-list) nil t)))
                 (when file
                   (find-file file))))

             ;; replaced by consult-recent-files
             ;; (global-set-key (kbd "C-x C-r") 'recentf-find-file)
             ;; open recent files, same as M-x rf

             ;; now if I incidentally closed a  buffer, I can re-open it, thanks to
             ;; recent-files
             (defun undo-kill-buffer (arg)
               "Re-open the last buffer killed.  With ARG, re-open the nth buffer."
               (interactive "p")
               (let ((recently-killed-list (copy-sequence recentf-list))
                     (buffer-files-list
                      (delq nil (mapcar (lambda (buf)
                                          (when (buffer-file-name buf)
                                            (expand-file-name (buffer-file-name buf)))) (buffer-list)))))
                 (mapc
                  (lambda (buf-file)
                    (setq recently-killed-list
                          (delq buf-file recently-killed-list)))
                  buffer-files-list)
                 (find-file
                  (if arg (nth arg recently-killed-list)
                    (car recently-killed-list)))))

             ;; exclude some auto generated files
             (setq recentf-exclude (list "ido.last"
                                         "/elpa/"
                                         ".el.gz$"
                                         '(not (file-readable-p)))))


(provide 'init-recentfiles)
;;; init-recentfiles.el ends here
