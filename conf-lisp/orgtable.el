;; *** org table mode

;; I'm so used to lovely org mode tables, I need them everywhere!
(when (package-installed-p 'org)
  (require 'org-table)


  ;; convert CSV region to table
  (defun tablify (regex)
    "Convert a whitespace separated column list into
an org mode table and enable orgtbl-mode. You can
specify another regex for cell splitting."
    (interactive "MConvert [region] to table with regex ([\t\s]+): ")
    (let ((spc "[\t\s]+"))
      (when (string= regex "")
        (setq regex spc))
      (delete-trailing-whitespace)
      (if (org-region-active-p)
          (org-table-convert-region (region-beginning) (region-end) regex)
        (org-table-convert-region (point-min) (point-max) regex))
      (when (not (eq major-mode 'org-mode))
        (orgtbl-mode))))

  ;; table sorting shortcuts
  (defun sort-table-numeric ()
    "sort org table numerically by current column"
    (interactive)
    (org-table-sort-lines nil ?n))

  (defun sort-table-numeric-desc ()
    "reverse sort org table numerically by current column"
    (interactive)
    (org-table-sort-lines nil ?N))

  (defun sort-table-alphanumeric ()
    "sort org table charwise by current column"
    (interactive)
    (org-table-sort-lines nil ?a))

  (defun sort-table-alphanumeric-desc ()
    "reverse sort org table charwise by current column"
    (interactive)
    (org-table-sort-lines nil ?A))

  (defun sort-table-time ()
    "sort org table by times by current column"
    (interactive)
    (org-table-sort-lines nil ?t))

  (defun sort-table-time-desc ()
    "reverse sort org table by times by current column"
    (interactive)
    (org-table-sort-lines nil ?T))

  ;; [[http://irreal.org/blog/?p=3542][via jcs/irreal.org]]
  ;; however, I renamed the actual sort wrappers to match my
  ;; naming scheme
  (defun jcs-ip-lessp (ip1 ip2 &optional op)
    "Compare two IP addresses.
Unless the optional argument OP is provided, this function will return T
if IP1 is less than IP2 or NIL otherwise. The optional argument OP is
intended to be #'> to support reverse sorting."
    (setq cmp (or op #'<))
    (cl-labels ((compare (l1 l2)
                         (if (or (null l1) (null l2))
                             nil
                           (let ((n1 (string-to-number (car l1)))
                                 (n2 (string-to-number (car l2))))
                             (cond
                              ((funcall cmp n1 n2) t)
                              ((= n1 n2) (compare (cdr l1) (cdr l2)))
                              (t nil))))))
      (compare (split-string ip1 "\\.") (split-string ip2 "\\."))))

  (defun sort-table-ip ()
    (interactive)
    (org-table-sort-lines nil ?f #'org-sort-remove-invisible #'jcs-ip-lessp))

  (defun sort-table-ip-desc ()
    (interactive)
    (org-table-sort-lines nil ?F #'org-sort-remove-invisible
                          (lambda (ip1 ip2) (jcs-ip-lessp ip1 ip2 #'>))))


  ;; easy access for the shortcuts
  (defalias 'stn       'sort-table-numeric)
  (defalias 'stnd      'sort-table-numeric-desc)
  (defalias 'sta       'sort-table-alphanumeric)
  (defalias 'stad      'sort-table-alphanumeric-desc)
  (defalias 'stt       'sort-table-time)
  (defalias 'sttd      'sort-table-time-desc)
  (defalias 'sti       'sort-table-ip)
  (defalias 'stid      'sort-table-ip-desc)

  ;; generic table exporter
  (defun tvd-export-org-table (fmt)
    "export an org table using format FMT"
    (interactive)
    (let ((efile "/tmp/org-table-export.tmp")
          (ebuf (format "*table-%s*" fmt)))
      (when (file-exists-p efile)
        (delete-file efile))
      (org-table-export efile (format "orgtbl-to-%s" fmt))
      (other-window 1)
      (if (not (eq (get-buffer ebuf) nil))
          (kill-buffer (get-buffer ebuf)))
      (set-buffer (get-buffer-create ebuf))
      (insert-file-contents efile)
      (switch-to-buffer ebuf)
      (delete-file efile)))

  ;; FIXME: once there's an org solution to this, remove this code
  ;; format specific exporters
  (defun tvd-org-quote-csv-field (s)
    "Quote every field."
    (if (string-match "." s)
        (concat "=\"" (mapconcat 'identity
                                 (split-string s "\"") "\"\"") "\"")
      s))

  (defun table-to-excel ()
    "export current org table to CSV format suitable for MS Excel."
    (interactive)
    ;; quote everything, map temporarily 'org-quote-csv-field
    ;; to my version
    (cl-letf (((symbol-function 'org-quote-csv-field)
               #'tvd-org-quote-csv-field))
      (tvd-export-org-table "csv")))

  (defun table-to-csv ()
    "export current org table to CSV format"
    (interactive)
    (tvd-export-org-table "csv"))

  (defun table-to-latex ()
    "export current org table to LaTeX format"
    (interactive)
    (tvd-export-org-table "latex"))

  (defun table-to-html ()
    "export current org table to HTML format"
    (interactive)
    (tvd-export-org-table "html"))

  (defun table-to-csv-tab ()
    "export current org table to CSV format, separated by <tab>"
    (interactive)
    (tvd-export-org-table "tsv"))

  (defun table-to-aligned ()
    "export current org table to space-aligned columns format"
    (interactive)
    (tvd-export-org-table "csv")
    (with-current-buffer "*table-csv*"
      (align-regexp (point-min) (point-max) "\\(\\s-*\\)," 1 1 t)
      (while (re-search-forward " ," nil t)
        (replace-match "    "))))

  ;; exporter shortcuts
  (defalias 'ttc      'table-to-csv)
  (defalias 'tte      'table-to-excel)
  (defalias 'ttl      'table-to-latex)
  (defalias 'tth      'table-to-html)
  (defalias 'ttt      'table-to-csv-tab)
  (defalias 'tta      'table-to-aligned)

  ;; In org mode I sometimes want to copy the content of a table cell
  (defun tvd-beginning-of-cell (&optional arg)
    "move (point) to the beginning of a org mode table cell"
    (interactive)
    (if  (re-search-backward "|" (line-beginning-position) 3 1)
        (forward-char)))

  (defun tvd-end-of-cell (&optional arg)
    "move (point) to the end of a org mode table cell"
    (interactive)
    (if  (re-search-forward "|" (line-end-position) 3 1)
        (backward-char)))

  (defun tvd-copy-org-table-cell(&optional arg)
    "Copy an org mode table cell to the kill ring using MCYT"
    (interactive "P")
    (mcyt--blink-and-copy-thing 'tvd-beginning-of-cell 'tvd-end-of-cell arg))

  (defun tvd-del-org-table-cell (&optional arg)
    "Delete a cell"
    (interactive "P")
    (let
        ((beg (progn (tvd-beginning-of-cell) (point)))
         (end (progn (tvd-end-of-cell) (point))))
      (delete-region beg end)
      (org-table-align)))

  (defun tvd-del-org-table-row ()
    "Delete a table row's contents"
    (interactive)
    (org-beginning-of-line 1)
    (kill-line)
    (org-table-insert-row nil))

  (defun tvd-del-org-table-col ()
    "Delete a table column's contents, keep heading as is"
    (interactive)
    (let ((head (org-table-get 1 nil)))
      (org-table-delete-column)
      (re-search-forward "|")
      (org-table-insert-column)
      (tvd-org-table-goto-col-beginning)
      (insert head)
      (org-table-align))
    )

  ;; Sometimes I need to copy whole columns too:
  ;; via [[https://emacs.stackexchange.com/questions/28270/how-to-select-and-copy-a-column-of-an-org-table-without-rectangle-selection][stackoverflow]]

  (defun tvd-org-table-goto-col-beginning ()
    "Go to beginning of current column and return `point'."
    (interactive)
    (assert (org-table-p) "Not in org-table.")
    (org-table-align)
    (let ((col (org-table-current-column)))
      (goto-char (org-table-begin))
      (org-table-goto-column col))
    (point))

  (defun tvd-org-table-col-beginning ()
    "Return beginning position of current column."
    (save-excursion
      (tvd-org-table-goto-col-beginning)))

  (defun tvd-org-table-goto-col-end ()
    "Goto end of current column and return `point'."
    (interactive)
    (assert (org-table-p) "Not in org-table.")
    (org-table-align)
    (let ((col (org-table-current-column)))
      (goto-char (1- (org-table-end)))
      (org-table-goto-column col)
      (skip-chars-forward "^|"))
    (point))

  (defun tvd-org-table-col-end ()
    "Return end position of current column."
    (save-excursion
      (tvd-org-table-goto-col-end)))

  (defun tvd-org-table-select-col ()
    "Select current column."
    (interactive)
    (set-mark (tvd-org-table-col-beginning))
    (tvd-org-table-goto-col-end)
    (rectangle-mark-mode))

  (defun tvd-copy-org-table-col ()
    "Copy current column."
    (interactive)
    (tvd-org-table-select-col)
    (sit-for 0.2 t)
    (copy-region-as-kill nil nil t)
    (with-temp-buffer
      (yank)
      (delete-trailing-whitespace)
      (delete-whitespace-rectangle (point-min) (point-max))
      (font-lock-unfontify-buffer)
      (copy-region-as-kill (point-min) (point-max))))

  (defun tvd-copy-org-table-row ()
    "Copy current row, space aligned"
    (interactive)
    (mcyt-copy-line)
    (with-temp-buffer
      (yank)
      (goto-char (point-min))
      (let ((spc ""))
        (while (re-search-forward "|[ ]*" nil t)
          (replace-match spc)
          (setq spc " ")))
      (delete-trailing-whitespace)
      (copy-region-as-kill (point-min) (point-max))))

  ;; Move single cells using C-M-up C-M-down C-M-left C-M-right
  ;; [[https://cs.gmu.edu/~kauffman/software/org-table-move-single-cell.el][via Kauffmann]]
  (defun org-table-swap-cells (i1 j1 i2 j2)
    "Swap two cells"
    (let ((c1 (org-table-get i1 j1))
          (c2 (org-table-get i2 j2)))
      (org-table-put i1 j1 c2)
      (org-table-put i2 j2 c1)
      (org-table-align)))

  (defun org-table-move-single-cell (direction)
    "Move the current cell in a cardinal direction according to the
  parameter symbol: 'up 'down 'left 'right. Swaps contents of
  adjacent cell with current one."
    (unless (org-at-table-p)
      (error "No table at point"))
    (let ((di 0) (dj 0))
      (cond ((equal direction 'up) (setq di -1))
            ((equal direction 'down) (setq di +1))
            ((equal direction 'left) (setq dj -1))
            ((equal direction 'right) (setq dj +1))
            (t (error "Not a valid direction, must be up down left right")))
      (let* ((i1 (org-table-current-line))
             (j1 (org-table-current-column))
             (i2 (+ i1 di))
             (j2 (+ j1 dj)))
        (org-table-swap-cells i1 j1 i2 j2)
        (org-table-goto-line i2)
        (org-table-goto-column j2))))

  (defun org-table-move-single-cell-up ()
    "Move a single cell up in a table; swap with anything in target cell"
    (interactive)
    (org-table-move-single-cell 'up))

  (defun org-table-move-single-cell-down ()
    "Move a single cell down in a table; swap with anything in target cell"
    (interactive)
    (org-table-move-single-cell 'down))

  (defun org-table-move-single-cell-left ()
    "Move a single cell left in a table; swap with anything in target cell"
    (interactive)
    (org-table-move-single-cell 'left))

  (defun org-table-move-single-cell-right ()
    "Move a single cell right in a table; swap with anything in target cell"
    (interactive)
    (org-table-move-single-cell 'right))

  ;; actual org table config
  (with-eval-after-load "org"
    (add-hook 'org-mode-hook
              (lambda ()
                (local-set-key (kbd "C-c t l") 'tvd-copy-org-table-col)
                (local-set-key (kbd "C-c t r") 'tvd-copy-org-table-row)
                (local-set-key (kbd "C-c t c") 'tvd-copy-org-table-cell)
                (local-set-key (kbd "C-M-<left>")  'org-table-move-single-cell-left)
                (local-set-key (kbd "C-M-<right>") 'org-table-move-single-cell-right)
                (local-set-key (kbd "C-M-<up>")    'org-table-move-single-cell-up)
                (local-set-key (kbd "C-M-<down>")  'org-table-move-single-cell-down))))

  ;; eval-after-load 'orgtbl doesn't work
  (add-hook 'orgtbl-mode-hook '(lambda ()
                                 (define-key orgtbl-mode-map (kbd "C-c t l") 'tvd-copy-org-table-col)
                                 (define-key orgtbl-mode-map (kbd "C-c t r") 'tvd-copy-org-table-row)
                                 (define-key orgtbl-mode-map (kbd "C-c t c") 'tvd-copy-org-table-cell)))

  ;; integers, reals, positives, set via custom
  (setq org-table-number-regexp "^[-+]?\\([0-9]*\\.[0-9]+\\|[0-9]+\\.?[0-9]*\\)$")

  ;; table hydras, maybe better than aliases?!
  (defhydra hydra-org-tables (:color blue)
    "
^Sort by^             ^Transform to^      ^Copy/Del what^                ^Modify^                 ^Outside Org^
^^^^^^^^-----------------------------------------------------------------------------------------------------------------------
_sa_:  alphanumeric   _tc_: CSV           _cl_: Copy Column (C-c t l)    _ic_: Insert Column      _ot_: Table to Org Mode
_sA_: -alphanumeric   _te_: Excel         _cr_: Copy Row    (C-c t r)    _ir_: Insert Row         _oe_: Enable Org-Tbl Mode
_si_:  ip             _tl_: Latex         _cc_: Copy Cell   (C-c t c)    _il_: Insert Line        _oc_: Turn region to columns
_sI_: -ip             _th_: HTML          _dd_: Delete Cell              _tr_: Transpose Table
_sn_:  numeric        _tt_: Tab           _dc_: Delete Column            _mr_: Move Cell right
_sN_: -numeric        _ta_: Aligned       _dr_: Delete Row               _ml_: Move Cell left
_st_:  time           ^^                  _kr_: Kill Row                 _mu_: Move Cell up
_sT_: -time           ^^                  _kc_: Kill Column              _md_: Move Cell down     _q_: Cancel


^^^^^^^^-----------------------------------------------------------------------------------------------------------------------
Reach this hydra with <C-x t>
^^^^^^^^-----------------------------------------------------------------------------------------------------------------------


"
    ("mr" org-table-move-single-cell-right)
    ("ml" org-table-move-single-cell-left)
    ("mu" org-table-move-single-cell-up)
    ("md" org-table-move-single-cell-down)
    ("sa" sort-table-alphanumeric  nil)
    ("sA" sort-table-alphanumeric-desc nil)
    ("si" sort-table-ip nil)
    ("sI" sort-table-ip-desc  nil)
    ("sn" sort-table-numeric  nil)
    ("sN" sort-table-numeric-desc  nil)
    ("st" sort-table-time  nil)
    ("sT" sort-table-time-desc  nil)

    ("tc" table-to-csv nil)
    ("te" table-to-excel    nil)
    ("tl" table-to-latex    nil)
    ("th" table-to-html     nil)
    ("tt" table-to-csv-tab  nil)
    ("ta" table-to-aligned  nil)

    ("cl" tvd-copy-org-table-col nil)
    ("cr" tvd-copy-org-table-row nil)
    ("cc" tvd-copy-org-table-cell nil)
    ("dd" org-table-blank-field nil)
    ("dr" tvd-del-org-table-row nil)
    ("dc" tvd-del-org-table-col nil)
    ("kc" org-table-delete-column nil)
    ("kr" org-table-kill-row nil)

    ("ic" org-table-insert-column nil)
    ("ir" org-table-insert-row nil)
    ("il" org-table-hline-and-move nil)
    ("tr" org-table-transpose-table-at-point nil)

    ("ot" tablify  nil)
    ("oe" orgtbl-mode nil)
    ("oc" align-repeat nil)

    ("q" nil nil :color red))

  ;; allow me to insert org tables everywhere on request
  (defalias 'table     'hydra-org-tables/body)
  (global-set-key (kbd "C-x t") 'hydra-org-tables/body))
