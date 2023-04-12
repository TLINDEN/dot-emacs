;; *** org agenda mode

;; I use org mode  for along time now, primarily at  work, but did not
;; use agenda.  Instead  I developed the habit of  maintaining one org
;; entry which  contains just a  list with all  things to do  today. I
;; just edited this list manually  and it worked.  However, recently I
;; found  out  that agenda  provides  lots  of features  and  commands
;; precisely for what I already did  manually. So, now, finally (as of
;; november 2018) I switch to using the agenda.

;; My agenda use is very simple though: I don't use any scheduling, no
;; priorities,  no recurring  events,  no daily  or  other time  based
;; views. I just keep a list of TODO entries and another of entries in
;; WAIT  state, that's  it.  All  those entries  are  located under  a
;; special  org entry  with the  title  "Heute" and  the category  (as
;; property) WORK, which I use for filtering out agenda items.

;; The general workflow is as follows: I execute (agenda) which starts
;; directly  my custom  agenda view.   It  lists open  TODO items  and
;; waiting WAIT  items below. If  I press `n', I  will be asked  for a
;; title and a new TODO item appears  in my agenda. I can press `d' to
;; mark it as  DONE, it will also be archived  into a subsibling below
;; "HEUTE". I can press `w' to move  an item into WAIT state and I can
;; press `a' to  add text to the org entry  under point (like "waiting
;; for customer email").

;; So, I  don't use my  regular org entries,  which are in  most cases
;; very large  containing lots  of information,  as agenda  items, but
;; only very short ones which act  as reminders about what work I have
;; to  do. However,  since I  have the  org buffer  always opened  and
;; visible in a split  buffer next to the agenda, it  is no problem to
;; go to such a deep entry for editing or viewing.

(when (package-installed-p 'org)
  (require 'org-agenda)

  ;; This is my one and only  agenda custom view, it displays TODO items
  ;; below entries  categorized as  WORK and WAIT  items under  the same
  ;; category. The cool  thing here is, that the `tags'  agenda view can
  ;; be used  to filter for  properties as well.  In order to  have this
  ;; working the following  property drawer must exist in  an entry with
  ;; TODO siblings:
  ;;
  ;;    * START Arbeit
  ;;      :PROPERTIES:
  ;;      :CATEGORY: WORK
  ;;      :END:
  ;;    ** TODO a thing to do
  ;;    ** WAIT a thing waiting for something
  ;;
  (setq org-agenda-custom-commands
        '(("o" "Daily TODO Tasks"
           (
            ;; a block containing only items scheduled for today, if any
            (agenda ""
                    ((org-agenda-span 1)
                     (org-agenda-overriding-header "Tasks scheduled:")))
            ;; manually created todo items due (state TODO)
            (tags "CATEGORY=\"WORK\""
                  ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("CANCEL" "START" "DONE" "WAIT")))
                   (org-agenda-overriding-header "\nTasks to do today:")
                   (org-agenda-follow-mode t)
                   (org-agenda-entry-text-mode t)))
            ;; manually created todo items in wait state
            (tags "CATEGORY=\"WORK\""
                  ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("CANCEL" "START" "DONE" "TODO")))
                   (org-agenda-overriding-header "\nTasks Waiting:"))))
           ((org-agenda-compact-blocks t)))))

  ;; A shortcut to reach my custom view directly
  (defun agenda ()
    "Visit my org agenda directly, splits left"
    (interactive)
    (org-agenda nil "o")
    (tvd-flip-windows)
    (other-window-or-switch-buffer))

  ;; Add a line of text to the top of an existing TODO entry and refresh
  ;; the agenda
  (defun tvd-org-agenda-edit-entry (note)
    "Insert a note as plain text into an entry"
    (interactive "sEnter note: ")
    (save-excursion
      (org-agenda-switch-to)
      (end-of-line)
      (newline)
      (insert note))
    (switch-to-buffer "*Org Agenda*")
    (org-agenda-redo t))

  ;; Mark an entry as DONE, archive it to an archive sibling and refresh
  ;; the agenda
  (defun tvd-org-agenda-done()
    (interactive)
    (org-agenda-todo 'done)
    (org-agenda-archive-to-archive-sibling)
    (org-agenda-redo t))

  ;; Mark an entry as WAIT, archive it to an archive sibling and refresh
  ;; the agenda
  (defun tvd-org-agenda-wait()
    (interactive)
    (org-agenda-todo "WAIT")
    (org-agenda-redo t))

  ;; A  wrapper which  executes  an  org capture  directly.  `t' is  the
  ;; shortcut for the capture, defined above in org mode.
  (defun tvd-org-agenda-capture (task)
    "Capture a task in agenda mode, using the date at point"
    (interactive)
    (let ((org-overriding-default-time (org-get-cursor-date)))
      (org-capture nil task)
      (org-agenda-redo t)))

  (defun tvd-org-agenda-capture-todo ()
    "Capture a todo task in agenda mode"
    (interactive)
    (tvd-org-agenda-capture "t"))

  (defun tvd-org-agenda-capture-scheduled ()
    "Capture a scheduled task in agenda mode"
    (interactive)
    (tvd-org-agenda-capture "s"))


  ;; Sometimes  it  is  nice  to  see  the  agenda  alone,  so  I  press
  ;; `o'. However, since follow mode is  enabled, once I move point, the
  ;; org buffer re-appears.
  (defun tvd-org-agenda-solitair ()
    (interactive)
    (delete-other-windows)
    (setq org-agenda-follow-mode nil)
    (message "Org Agenda Follow Mode Disabled"))

  ;; The original function scrolls the buffer  every time when it runs a
  ;; little bit up, which is annoying, to say the least
  (defun tvd-org-agenda-redo()
    (interactive)
    (org-agenda-redo t)
    (beginning-of-buffer))

  ;; Since I learned to love hydra, I have one for my agenda as well, of course:
  (defhydra hydra-org-agenda (:color blue
                                     :pre (setq which-key-inhibit t)
                                     :post (setq which-key-inhibit nil)
                                     :hint none)
    "
Org Agenda (_q_uit)

^Tasks^                             ^Options^             ^Movement^
-^^^^^^-------------------------------------------------------------------------------------
_n_: create new todo task           _f_: follow =?f?      ENTER:     switch to entry
_N_: create new scheduled task      _e_: entry  =?e?      C-<up>:    go one entry up
_d_: mark task done and archive     _o_: one window       C-<down>:  go one entry down
_w_: mark task waiting              ^^                    M-<up>:    move entry up
_t_: toggle todo state              ^^                    M-<down>:  move entry down
_z_: archive task                   ^ ^
_+_: increase prio
_-_: decrease prio                  ^Marking^
_g_: refresh                        _m_: mark entry
_s_: save org buffer(s)             _u_: un-mark entry
_a_: add a note to the entry        _U_: un-mark all
_k_: delete a task w/o archiving    _B_: bulk action

"
    ("a" tvd-org-agenda-edit-entry nil)
    ("n" tvd-org-agenda-capture-todo nil)
    ("N" tvd-org-agenda-capture-scheduled nil)
    ("o" tvd-org-agenda-solitair nil)
    ("g" tvd-org-agenda-redo)
    ("t" org-agenda-todo)
    ("d" tvd-org-agenda-done nil)
    ("w" tvd-org-agenda-wait nil)
    ("z" org-agenda-archive-to-archive-sibling nil)
    ("+" org-agenda-priority-up nil)
    ("-" org-agenda-priority-down nil)
    ("s" org-save-all-org-buffers nil)
    ("f" org-agenda-follow-mode
     (format "% -3S" org-agenda-follow-mode))
    ("e" org-agenda-entry-text-mode
     (format "% -3S" org-agenda-entry-text-mode))
    ("m" org-agenda-bulk-mark nil)
    ("u" org-agenda-bulk-unmark nil)
    ("U" org-agenda-bulk-remove-all-marks nil)
    ("B" org-agenda-bulk-action nil)
    ("k" org-agenda-kill nil)
    ("q" nil nil :color red))

  ;; Configuration and key bindings for org agenda (same as in the hydra)
  (add-hook 'org-agenda-mode-hook '(lambda () (progn
                                                (setq org-agenda-follow-mode t
                                                      org-log-into-drawer t
                                                      org-agenda-entry-text-mode t
                                                      org-agenda-sorting-strategy '(priority-down timestamp-down))
                                                (local-set-key (kbd "n") 'tvd-org-agenda-capture-todo)
                                                (local-set-key (kbd "N") 'tvd-org-agenda-capture-scheduled)
                                                (local-set-key (kbd "o") 'tvd-org-agenda-solitair)
                                                (local-set-key (kbd "a") 'tvd-org-agenda-edit-entry)
                                                (local-set-key (kbd "d") 'tvd-org-agenda-done)
                                                (local-set-key (kbd "w") 'tvd-org-agenda-wait)
                                                (local-set-key (kbd "g") 'tvd-org-agenda-redo)
                                                (local-set-key (kbd "f") 'org-agenda-follow-mode)
                                                (local-set-key (kbd "e") 'org-agenda-entry-text-mode)
                                                (local-set-key (kbd "k") 'org-agenda-kill)
                                                (local-set-key (kbd "z") 'org-agenda-archive-to-archive-sibling)
                                                (local-set-key (kbd "C-<up>") 'org-agenda-previous-item)
                                                (local-set-key (kbd "C-<down>") 'org-agenda-next-item)
                                                (local-set-key (kbd "?") 'hydra-org-agenda/body)))))
