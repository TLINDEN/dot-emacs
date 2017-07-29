;; Generate an alist of all headings  with each position in buffer and
;; use this later to jump to those positions with IDO.
(make-variable-buffer-local 'tvd-headings)

(defun tvd-outshine-get-level (heading)
  "Return level of HEADING as number, or nil"
  (if (string-match " \\(*+\\) " heading) ; normal outline heading
      (length (match-string 1 heading))
    (when (string-match "^;;\\(;+\\) " heading) ; else look for elisp heading
      (length (match-string 1 heading)))))

(defun tvd-outshine-cl-heading (heading)
  (let ((regex (cadar outshine-imenu-preliminary-generic-expression)))
    (when (string-match regex heading)
      (match-string-no-properties 1 heading))))

(defun tvd-outshine-parse-headings ()
  "extract outshine headings of current buffer"
  (interactive)
  (let ((line nil))
    (save-excursion
      (setq tvd-headings ())
      (beginning-of-buffer)
      (while (not (eobp))
        (setq line (tvd-get-line))
        (when (outline-on-heading-p t)
          (add-to-list 'tvd-headings (cons (tvd-outshine-cl-heading line) (point))))
        (forward-line)))))

(defun tvd-outshine-sparse-tree ()
  "expand outline tree from current position as sparse tree"
  (interactive)
  (let ((done nil)
        (pos (point))
        (tree (list (list (point) 5)))
        (l 0))
    (while (not done)
      (outline-up-heading 1)
      (setq l (tvd-outshine-get-level (tvd-get-line)))
      (add-to-list 'tree (list (point) l))
      (when (eq l 1)
        (setq done t)))
    (outline-hide-other)
    (dolist (pos tree)
      (goto-char (car pos))
      (outline-cycle))))

(defun tvd-outshine-jump ()
  "jump to an outshine heading with IDO prompt,
update heading list if neccessary."
  (interactive)
  (let ((heading nil))
    (when (or (not tvd-headings)
              (buffer-modified-p))
      (tvd-outshine-parse-headings))
    (if (not tvd-headings)
        (message "Current buffer doesn't contain any outshine headings!")
      (setq heading (ido-completing-read "Jump to heading: " (tvd-alist-keys tvd-headings)))
      (when heading
        (show-all)
        (goto-char (cdr (assoc heading tvd-headings)))
        (tvd-outshine-sparse-tree)))))

(eval-after-load "outline"
  '(progn
     (add-hook
      'outline-minor-mode-hook
      (lambda ()
        (define-key outline-minor-mode-map (kbd "C-c C-j")  'tvd-outshine-jump)))))

;; test
