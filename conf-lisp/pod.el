;; *** POD mode

;; I LOVE POD!  POD is the  documentation format of perl and there's a
;; solid toolset available for it. I use it to write documentation and
;; manual pages. It's  much more powerfull than lame  markdown and you
;; can even program  great tools yourself around POD (like  I did with
;; PodWiki years ago!)

;; Although cperl mode  already has some POD support, pod  mode is way
;; better.

;; Source: [[https://github.com/renormalist/emacs-pod-mode][emacs-pod-mode]]
(when (package-installed-p 'expand-region)
  ;; using expand-region: apply pod entity formatting to word at point.
  (defun tvd-outline-emphasize(CHAR)
    "expand once if no region and apply emphasize CHAR"
    (interactive)
    (unless (use-region-p)
      (er/expand-region 1))
    (save-excursion
      (goto-char (region-beginning))
      (insert (format "%c<" CHAR))
      (goto-char (region-end))
      (insert ">")))

  (defun pod-bold()
    "bold text in outline mode"
    (interactive)
    (tvd-outline-emphasize ?B))

  (defun pod-italic()
    "italic text in outline mode"
    (interactive)
    (tvd-outline-emphasize ?I))

  (defun pod-code()
    "verbatim text in outline mode"
    (interactive)
    (tvd-outline-emphasize ?C))

  ;; enhance abbrevs and jump into expanded area to the
  ;; $ character (if it exists), which it also removes
  (setq tvd-abbrev-pos 0)
  (advice-add 'expand-abbrev :before
              '(lambda () (setq tvd-abbrev-pos (point))))
  (advice-add 'expand-abbrev :after
              '(lambda ()
                 (ignore-errors
                   (when (re-search-backward "\\$" (- tvd-abbrev-pos 0))
                     (delete-char 1))))))

(use-package pod-mode
             :ensure nil ;; static install
             :mode "\\.pod\\'"

             :config
             (add-hook 'pod-mode-hook 'font-lock-mode)

             ;; tune syntax table
             (modify-syntax-entry ?= "w" pod-mode-syntax-table)

             ;; POD contains headers and I'm used to outlining if there are headers
             ;; so, enable outlining
             (setq outline-heading-alist '(("=head1" . 1)
                                           ("=head2" . 2)
                                           ("=head3" . 3)
                                           ("=head4" . 4)
                                           ("=over" . 5)
                                           ("=item" . 6)
                                           ("=begin" . 5)
                                           ("=pod" . 5)
                                           ))

             ;; outline alone, however, works well
             (outline-minor-mode)

             ;; my own abbrevs for POD using mode-specific abbrev table
             (define-abbrev-table 'pod-mode-abbrev-table '(
                                                           ("=o" "=over\n\n=item *$\n\n=back\n\n")
                                                           ("=i" "=item ")
                                                           ("=h1" "=head1 ")
                                                           ("=h2" "=head2 ")
                                                           ("=h3" "=head3 ")
                                                           ("=h4" "=head4 ")
                                                           ("=c"  "=cut")
                                                           ("=b"  "=begin")
                                                           ("=e"  "=end")
                                                           ("b"  "B<$>")
                                                           ("c"  "C<$>")
                                                           ("l"  "L<$>")
                                                           ("i"  "I<$>")
                                                           ("e"  "E<$>")
                                                           ("f"  "F<$>"))
               "POD mode abbreviations, see .emacs")

             (abbrev-table-put pod-mode-abbrev-table :case-fixed t)
             (abbrev-table-put pod-mode-abbrev-table :system t)

             ;; enable abbreviations
             (setq local-abbrev-table pod-mode-abbrev-table)
             (abbrev-mode 1)

             ;; POD easy formatting
             (local-set-key (kbd "C-c b") 'pod-bold)
             (local-set-key (kbd "C-c /") 'pod-italic)
             (local-set-key (kbd "C-c c") 'pod-code))
