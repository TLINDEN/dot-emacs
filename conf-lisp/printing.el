;; *** Printing
;; overwrites printing default menu, access via menu File => Print
;; or:
;; - M-x ps-spool-buffer-with-faces
;; - go to *spool* buffer
;; - save to .ps file
;; - print
(require 'printing)
(pr-menu-bind)

;; via [[https://emacs.stackexchange.com/questions/9364/convert-a-text-buffer-to-a-pdf-file][stackoverflow]]
(when (executable-find "ps2pdf")
  (defun print-to-pdf (&optional filename)
    "Print file in the current buffer as pdf, including font, color, and
underline information.  This command works only if you are using a window system,
so it has a way to determine color values.

C-u COMMAND prompts user where to save the Postscript file (which is then
converted to PDF at the same location."
    (interactive (list (if current-prefix-arg
                           (ps-print-preprint 4)
                         (concat (file-name-sans-extension (buffer-file-name))
                                 ".ps"))))
    (ps-print-with-faces (point-min) (point-max) filename)
    (shell-command (concat "ps2pdf " filename))
    (delete-file filename)
    (message "Deleted %s" filename)
    (message "Wrote %s" (concat (file-name-sans-extension filename) ".pdf"))))
