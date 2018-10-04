;; Toms Emacs Config - portable - version (20181004.01)          -*-emacs-lisp-*-
;; * Introduction

;; This  is my  emacs config,  it is  more than  twenty years  old. It
;; mostly contains  stuff implemented  by myself,  but there  are also
;; snippets I  found here and there.  The config will probably  not be
;; usefull for anyone else but myself.

;; If you're reading the html exported  version: be advised, that I do
;; NOT maintain my emacs config with "literate programming". Instead I
;; maintain a plain old .emacs file, which  I use at home and work, on
;; windows, linux  and freebsd, console  or X11. I use  outshine minor
;; mode to  organize my config  and I use outorg  to export it  to org
;; mode and from there to html.

;; Also I  don't use any  packaging mechanism, instead I  download all
;; the  required  elisp  files  manually   and  update  them  only  if
;; required. There's a melpa config toggle though, which I only use to
;; try out  new modes. I  distribute my  .emacs config along  with the
;; lisp directory to all systems where  I need it using a Makefile and
;; scp.  The  reason is  that I  work on a  couple of  systems without
;; direct internet  access, where packaging  or git don't work.  So, I
;; don't use these things nowhere. It's ok for me, I'm used to it.

;; Another  thing  you might  wonder  about  are  my key  bindings  or
;; (sometimes) the lack thereof. My  problem with key bindings is that
;; I don't have any useful prefixes  left. I am using ONLY commandline
;; tools,  my  window  manager  is  Xmonad, I  use  screen,  bash  and
;; mutt. The  only applications where I  use the mouse is  firefox and
;; gimp. So,  it is very hard  to avoid conflicts AND  memoize new key
;; bindings. Some key bindings are  so deeply wired into muscle memory
;; that I could use them while drunk or dying.

;; Therefore I  use lots of  aliases in emacs for  not-so-regular used
;; functions, which turned out to be  sometimes easier to type than an
;; actual key binding.

;; The   html   export   has    been   created   with   the   function
;; outshine-to-html, written by myself, see below.


;; * Config Log, Trivia, Notes, Changes
;; ** Changelog

;; 20160420.03:
;;    - started with Changelog and outshine mode
;;    - fixed tabs
;;    - reorganized keys
;;    - added new goto line func

;; 20160421.01:
;;    - added smex
;;    - added show-keys()
;;    - added redo
;;    - ssh et. al. interactive in eshell
;;    - added recompile()

;; 20160421.02:
;;    - added dividers
;;    - using org headers
;;    - better show-keys()

;; 20160421.03:
;;    - added windows support

;; 20160421.04:
;;    - added elisp repl support

;; 20160424.01:
;;    - added custom modeline
;;    - added which-func-mode
;;    - shortened some major mode names
;;    - added diminish for shorter minor mode names
;;    - added better printing menu

;; 20160425.01:
;;    - fixed ielm integration
;;    - C-x e    = eval (buffer|region)
;;    - C-x C-e  = send (buffer|region) to ielm and eval there

;; 20160425.02:
;;    - fix word wrapping

;; 20160426.01:
;;    - fixed mode-line config 4 win emacs
;;    - added M-<up|down> move-region

;; 20160426.01:
;;    - added markdown

;; 20160427.01+02:
;;    - cosmetics

;; 20160428.01:
;;    - fringe cursor

;; 20160429.01:
;;    - file name completion
;;    - C-#  finally, search for symbol at point
;;    - C-c C-c now comments or uncomments regios or line, whatever is current

;; 20160501.01:
;;    - no outshine minor in python
;;    - added recent files support

;; 20160501.02:
;;    - added margin() function, no key binding though

;; 20160503.01:
;;    - added C-q fill+justify paragraph macro
;;    - added alias 'i' for info manuals

;; 20160503.02:
;;    - added 'cp to create read-only buffer copy

;; 20160504.01:
;;    - better fringe, now also inversed with C-c i

;; 20160505.01:
;;    - added electric-align mode
;;    - better outline header colors
;;    - no more line numbers in sk occur buffer

;; 20160507.01:
;;    - disable electric-align-momde (broken), using M-x align instead
;;    - hightlighting TABs with extra font

;; 20160509.01:
;;    - fixed margin()
;;    - discovered that C-x 0 deletes current window, god did I miss this one!

;; 20160510.01:
;;    - added kill-all-buffers()
;;  20160510.02:
;;    - no more load-file
;;    - added C-c [wlpa]: easy copy things at point
;;      without marking them

;; 20160511.01:
;;    - better buffer names with uniquify

;; 20160511.02:
;;    - copy-* functions now blink region
;;    - added del-* functions, bound to C-d:
;;      press multiple times to delete word, line, paragraph, buffer

;; 20160513.01:
;;    - fixed END key func

;; 20160516.01:
;;    - removed C-d stuff, replaced with vikiing-mode

;; 20160517.01:
;;    - changed highlight face
;;    - enabled debug-on-error in lispmode
;;    - enabled IDO mode globally, I just tend to love love love it

;; 20160517.02:
;;    - added workgroup.el, started experimenting
;;    - enabled Super_L (for workgroups)

;; 20160519.01:
;;    - fixed write-file, now ido mode is disabled for this one.

;; 20160520.01:
;;    - no x-sel on windows (C-v+C-c => emacs doesn't work anymore otherwise)
;;    - added eldoc mode to elisp hook

;; 20160520.02:
;;    - added novel-mode, for better reading

;; 20160522.01:
;;    - added vi's % jump paren emulation
;;    - enhanced novel-mode
;;    - enabled save-place mode which is VERY useful in combination with
;;      novel-mode

;; 20160523.01:
;;    - detached novel-mode into its own module, maintain on github
;;      enabled with C-n

;; 20160526.01:
;;    - added toggle-melpa

;; 20160527.01:
;;    - added htmlize

;; 20160529.01:
;;    - added html-listify

;; 20160530.01:
;;    - added key chords
;;    - added open-line-above+below

;; 20160602.01:
;;    - C-q now fills and pressing it again un-fills

;; 20160606.01:
;;    - deactivated key-chords, I didn't use them and they were annoying.

;; 20160609.01:
;;    - added puppet mode

;; 20160614.01:
;;    - added rotate-text (C-t)
;;    - added macro math  (C-x-0) (0 used as =)

;; 20160713.01:
;;    - fixed indent for Makefiles

;; 20160729.01:
;;    - rm duplicate abbr defs

;; 20160916.01:
;;    - enable mouse mark to copy

;; 20160926.01:
;;    - Dont kill-buffer, kill-this-buffer instead

;; 20160928.01:
;;    - change macro math C-x 0 to C-x C-0 so that C-0 is
;;      usable again for close window
;;    - elisp mode: debug-on-error only on non-cygwin

;; 20161011.01:
;;    - added dos2unix and unix2dos

;; 20161014.01:
;;    - fix auto-indent in conf-mode
;;    - force C-c C-c comment-uncomment in conf-mode

;; 20161018.01:
;;    - more effective conf-mode disarming (own defun)

;; 20161022.01:
;;    - better paren mode

;; 20161024.01:
;;    - fixed org mode hook

;; 20161027.01:
;;    - turn off tramp stuff in kill-all-buffers as well,
;;      so that after executing it, no more ssh prompt
;;      appears on C-x f.

;; 20161106.01:
;;    - added iedit mode with C-c e
;;    - added file-open support to eshell (aliases: vi + emacs)
;;    - much better C-l behavior in eshell (eshell/clear)

;; 20161205.01:
;;    - added SLIME, sbcl and paredit support, only loaded when exists

;; 20161206.01:
;;    - elisp mode: debug-on-error finally completeley disabled
;;    - added alias 'table, which enables org-mode table support everywhere

;; 20170205.01:
;;    - started with ETAGS support

;; 20170212.01:
;;    - added copy-defun (C-c f) to copy whole functions as is

;; 20170212.02:
;;    - now using € (alt-r + e) as jump to etag

;; 20170215.02:
;;    - added goto-last-change (C-b)
;;    - +test section
;;    - paredit

;; 20170215.02:
;;    - disabled workgoups mode, don't use it, doesn't load correctly
;;    - fixed windows switch, no more printing popup on startup

;; 20170220.01:
;;    - finally disabled aggressive-indent, it annoys more than it helps
;;    - added some bookmark aliases (bm, to, bl, like apparix)
;;    - added C-c y [..] copy+yank functions so that I can copy and paste
;;      stuff very fast with one key commbo, like yy in vi.
;;    - added copy-parens, copy-quote, copy-help (help message)

;; 20170220.02:
;;    - fixed C-c y y: indent correctly

;; 20170220.03:
;;    - fixed C-y+mouse-2: both use primary selection

;; 20170221.01:
;;    - added which-key

;; 20170223.01:
;;    - org-mode enhancements, C-n capture from everywhere
;;    - fixed org-mode todo keywords
;;    - fixed duplicate yank on win32 on mouse2

;; 20170223.01:
;;    - forgot to mv novel-mode to C-c C-n
;;    - better org heading faces

;; 20170224.01:
;;    - finally fixed C-t, now works everywhere
;;    - added more org short commands

;; 20170224.02:
;;    - fixed org-mode M-return
;;    - added support for windmove (WINDOWS-Key+Arrow: switch window)

;; 20170224.03:
;;    - better org colours

;; 20170224.03:
;;    - better org capture tpl (DRAFT)
;;    - capturing works now globally, even if no org file is open
;;    - using org-indent 4

;; 20170224.05:
;;    - fixed org tpls

;; 20170227.01:
;;    - fix cut/paste org subtress
;;    - M-o now switch buffer if 1 window, else switch window

;; 20170227.02:
;;    - added alias 'dp which displays everything
;;      there is to know about point (like current face, mode, etc)

;; 20170228.01:
;;    - org-refile now works recursivly with completion
;;    - org-refile also now uses ido-mode and completes in minibuffer
;;    - added alias '2table which converts CSV region to table
;;    - added shortcut formatting defuns 'bold, 'italic, 'underline and 'code
;;      which call 'org-emphasize respectively on current region,
;;      including key bindings with org mode keymap (C-c b,/,c,_)
;;    - hide emphasized markers in org mode
;;    - renamed 'recompile to 'recompile-el and fixed it
;;    - added 'info-find-file

;; 20170301.01:
;;    - added 'tvd-org-left-or-level-up bound to <C-left> in org mode
;;    - <C-up|down> in org mode now jump up on current level and
;;      fold current one and unfolds the target heading
;;    - enabled org-bullets
;;    - customized height of org-level faces

;; 20170301.02:
;;    - org mode emphasize shortcuts (C-c b...) expand region if
;;      theres no region active.

;; 20170301.03:
;;    - dis line num in org (faster)

;; 20170303.01:
;;    - elmacro support added, incl fix for org and outshine,
;;      F6 starts (or stops) a macro and displays the generated
;;      defun. CTRL-F6 executes the last macro interactively,
;;      <ret> repeats, a repeats til EOF, q aborts, e  enter macro
;;      (with completion)
;;    - C-x C-s on * elmacro ... * buffer stores it to tvd-macro-file

;; 20170305.01:
;;    - added elmacro defadvice, run after done with macro, it will
;;      be evaluated and saved along with a repeater defun.
;;    - display red [REC] hint on the mode-line while recording
;;    - added ~ shortcut for use inside IDO so I can reach $HOME
;;      very fast from everywhere, no more editing pre-filled
;;      current path and entering /home/$user/. Yeah!
;;    - added flip-window (bound to M-O (ALT-shift-o)
;;    - added cleanup-buffer (alias cb)
;;    - fixed C-<ret> and C-S-<ret>

;; 20170306.01:
;;    - re-enabled linenum mode
;;    - fixed custom modeline

;; 20170306.01:
;;    - which-func not in elisp anymore
;;    - added alias 'ee for 'eval-expression
;;    - added 'sa (show-aliases)
;;    - some occur enhancements for 'sk and 'sa.
;;    - note: inside *Occur*: q:quit, g:reload, e:edit (buffer must be open)

;; 20170307.01:
;;    - fixed 'sk and 'sa
;;    - added key bindings to mark things. M-a is the prefix, followed by:
;;      a - all, p - paragraph, f - function, l - line, w - word.
;;    - disabled M-O (flip-windows) on console emacs

;; 20170309.01:
;;    - added C-c s,u,e and M-a s,u,e

;; 20170309.02:
;;    - re-enabled paredit, its better in ielm and slime
;;    - added alias 'pe to quickly enable/disable par-edit
;;    - added virtual eShell dev /dev/log which stores stuff in *LOG*

;; 20170313.01:
;;    - iedit to C-c C-e, so C-c e works again (copy email)
;;    - put eshell aliases into .emacs(here) no need for aliases file anymore
;;    - added copy-comment (C-c c), copy-and-yank-comment (C-c y c) and
;;      m-mark-comment (M-a c)

;; 20170314.01:
;;    - enhanced copy-comment (that is, rewrote it), it now supports
;;      indented multiline comments

;; 20170315.01:
;;    - fixed C-c y [cpwf]
;;    - fixed copy[+yank+mark] word, it now includes - _ .
;;    - added copy-ip (C-c i), yank-ip (C-c y i) and mark-ip (M-a i)
;;    - copy-url alternatively copies file-path if it's no url at point
;;    - added numerical arg support to yy

;; 20170321.01:
;;    - rewrote copy-comment stuff, now supports blocks of comment
;;      after code etc.

;; 20170323.01:
;;    - moved the mark,copy,yank stuff into its own mode

;; 20170327.01:
;;    - added defadvice for mcyt mode, so that I can use C-v to
;;      always yank the last thing copied.

;; 20170502.01:
;;    - added config for ibuffer

;; 20170503.01:
;;    - added ibuffer-vc support

;; 20170503.02:
;;    - added ibuffer-tramp support
;;    - disabled ibuffer tab-collaps stuff

;; 20170505.01:
;;    - generalized init-dir+file variables, now more portable, i hope

;; 20170508.01:
;;    - backup tramp files remote
;;    - do not backup emacs state files

;; 20170509.01:
;;    - version fix

;; 20170523.01:
;;    - commented ssh backup stuff, not working yet, destroys tramp
;;    - added inferior shells for perl, ruby and python (iperl, iruby, ipython)
;;      with ansi-term

;; 20170610.01:
;;    - org mode: added C-c C-# to edit src blocks in an extra window
;;    - org mode: <ret> opens link in eww
;;    - ido-find-file advice: if not writable, try sudo/tramp
;;    - +eshell-there remote eshell (Alias: et)
;;    - disabled pager in eshell
;;    - fixed eshell/x, now uses C-d
;;    - org mode: DONE makes heading greyish
;;    - re-organized emacs config, now with subsections
;;    - removed lisp electric return, destroyed almost all modes
;;    - added POD mode with specific abbrevs and including specific outlining
;;    - added heading cycle code for outline mode as well
;;    - added outline 'n (narrow) + 'w (widen)
;;    - added orange fringe for narrowing (org, outline and everywhere else
;;    - added alias 'colors
;;    - added 'dl (aka describe-library to display the doc string in
;       COMMENTARY section of .el files
;;    - added "C-c t" to copy an org mode cell
;;    - ena org pretty entities, list: org-entities-help
;;    - 2table => tablify, which is now a function and uses region or whole buffer
;;    - added indirect narrowing buffers
;;    - renamed all occurences of my- to tvd- so I better know which stuff is mine
;;    - added table-to-* org table exporters with aliases
;;    - inside org mode: C-c o copy table c[o]lumn, C-c t copy [t]able cell
;;    - experimental: added beacon mode (blinking pointer)
;;      (moved 'seq from exp. elpa to lisp/)
;;    - added render-html to render current html buffer with eww
;;    - added align-regexp-repeat[-left|right] wrappers
;;    - fixed org mode C-<down|up> jump paragraphs if not on heading
;;    - added 'tvd-outshine-jump (alias 'j) to directly jump to headers
;;      with IDO completion and as sparse-tree, very cool!
;;      mapped to C-c C-j
;;    - added *text* scratch buffer with text mode
;;    - added jump-paren-match-or-insert-percent, bound to %, which jumps parens
;;      or inserts a % if not on a paren. Better than C-5, haha.
;;    - added 'ffxs
;;    - added emacs-change-log
;;    - removed GNUS config, not used anymore
;;    - restored C-d binding to viking in paredit
;;    - added outshine HTML exporter via org: outshine-to-html
;;    - fixed outshine config
;;    - added (my) config-general-mode
;;    - fixed pod format inserters

;; 20170629.01:
;;    - added tablist-minor-mode (+config)
;;    - added config for tabulated-list-mode
;;    - added config for help-mode
;;    - added default filename for outshine-to-html
;;    - Info mode: C-left+C-right history keys
;;    - added loader for el2markdown
;;    - removed smart-forward, it annoys me
;;    - made tvd-outshine-jump more portable, do not use hardcoded
;;      regexps anymore, use outshine functions
;;    - added 'change-inner and ci simulators'
;;    - added suggest.el with my own reload function
;;    - modified recentf: do not provide files already visited

;; 20170703.01:
;;    - fixed recentf-exclude list, now REALLY ignores unreadables
;;    - added export for easier export and commit of dot-emacs
;;    - added tvd-suggest-jump to jump between input and output

;; 20170707.01:
;;    - added C-x 4 to split fram into 4 windows
;;    - fixed config-general-mode config
;;    - fixed 'emacs-change-log (didn't expand trees before work)
;;    - fix python loading

;; 20170711.01:
;;    - fixed outshine: only loaded with elisp
;;    - fixed tvd-outshine-jump: use imenu if outside outshine
;;    - fixed kill-all-buffers: restore scratch after killing all buffers
;;    - do not ask to save abbrevs on exit anymore
;;    - reformat changelog
;;    - rm open-line-below

;; 20170711.02:
;;    - fixed POD abbrevs, added way to move point after expansion

;; 20170712.01:
;;    - disabled org mode superscripts
;;    - + winner mode
;;    - org mode 'code new binding: C-c 0
;;    - fixed emacs-change-log
;;    - added tvd-outshine-end-of-section incl speed command

;; 20170712.02:
;;    - fixed tvd-outshine-end-of-section, it's way faster now and
;;      works without narrowing.

;; 20170714.01:
;;    - fixed pod-mode abbrev cursor jumping if no jump pos exists
;;    - fix initial-buffer-choice
;;    - added mmm-mode
;;    - added here-doc support to config-general using mmm-mode
;;    - made outline faces a little bigger, added face for level 4
;;    - rm initial buffer, doesnt open commandline files anymore with this
;;    - finally initial buffer works, opens command line file or text scratch

;; 20170715.01:
;;    - no more MMM for C::G, destroys indent
;;    - incorporated my C::G customizations, Steve Purcell removed from
;;      it because inappropriate,
;;      [[https://github.com/TLINDEN/config-general-mode/commit/d7e8323][see d7e8323]]
;;    - fixed autoscratch hook
;;    - add scratch alias

;; 20170718.01:
;;    - better autoscratch config
;;    - added persistent-scratch mode

;; 20170719.01:
;;    - fixed electric-indent in autoscratch config
;;    - use my own autoscratch triggers
;;    - kill-all-buffers now uses 'autoscratch-buffer
;;    - renamce autoscratch
;;    - tuned recenter-positions

;; 20170722.01:
;;    - added followcursor-mode

;; 20170724.01:
;;    - added ido completion for tramp hostnames

;; 20170725.01:
;;    - autoscratch lambda=>progn
;;    - added sort-table-ip[desc] and fixed auto-alignment so
;;      that ip's are left aligned
;;    - +req org-table

;; 20170727.01:
;;    - +magit
;;    - configured magit dirs
;;    - +magit ido
;;    - fix magit info dir

;; 20170730.01
;;    - +some magit navigation keys

;; 20170731.01
;;    - do not load magit on w32
;;    - Always call `magit-status' with prefix arg
;;    - do bigger jumps in magit with just C-<up|down>
;;    - add "ls" to magit-status leading to dired

;; 20170801.01
;;    - added C command to magit to switch repo
;;    - add : trigger for ido-find-file to begin with tramp

;; 20170802.01
;;    - +table-to-excel
;;    - added some git wrappers to dired to add or rm files

;; 20170805.01
;;    - +C-c C-c for rename files in dired

;; 20170807.01
;;    - added dired config and functions
;;    - added dired-hacks: ranger and filters, enhanced navigation commands

;; 20170808.01
;;    - (i) is now a function, not an alias anymore and more comfortable
;;    - added org info path
;;    - added info+

;; 20170821.01
;;    - highlight line color light green with default bg

;; 20170901.01
;;    - added :jump-to-captured to org capture templates,
;;      didn't know about it before

;; 20170913.01
;;    - disabled outline in config-general-mode

;; 20170924.01
;;    - experimenting swiper

;; 20171201.01
;;    - highlight TABs with ruby as well

;; 20171205.01
;;    - fixed ORG template headings

;; 20180210.01
;;    - added ediff config
;;    - fixed ob-sh to ob-shell

;; 20180730.01
;;    - added autoscratch-reset-default-directory t

;; 20181004.01
;;    - added projectile and config
;;    - added hydra and config (for org tables and projectile)

;; ** TODO

;; - check dired hydra
;; - complete org table hydra

;; Old
;; - check helpful https://github.com/wilfred/helpful
;; - check no-littering https://github.com/tarsius/no-littering
;; - submit novel + mark-copy-yank-things-mode to MELPA
;; - put tvd-ci-* stuff into mcyt
;; - check https://github.com/Wilfred/refine
;;         https://github.com/Wilfred/emacs-refactor
;; - check https://github.com/Malabarba/speed-of-thought-lisp
;; - https://github.com/tkf/emacs-jedi

;; ** Parking Lot / Snippets

;; Snippets which maybe of use in the future

;; *** buffer-local hook

;; (with-current-buffer (get-buffer "*scratch*")
;;   (add-hook 'kill-buffer-hook
;;             (lambda () (error "DENIED! don't kill my precious *scratch*!!"))
;;             nil t))

;; --------------------------------------------------------------------------------
;; ** .emacs config version

;; My emacs  config has a  version (consisting  of a timestamp  with a
;; serial), which I display in the mode line. So I can clearly see, if
;; I'm using an outdated config somewhere.
(defvar tvd-emacs-version "20181004.01")

;; --------------------------------------------------------------------------------

;; * System Specifics
;; ** Global init file+dir vars, portable
;;    - added dev function which opens a new development frame

;; since I  always use ~/.emacs as  my init file, this  results in the
;; correct emacs dir:
(setq user-init-dir (expand-file-name (concat user-init-file ".d")))

;; FIXME: use (pwd) to determine .emacs.d, make it more portable
;; use different init dir on cygwin systems
(setq tvd-win-home "C:/Cygwin/home/iz00468")
(if (file-exists-p tvd-win-home)
    (setq user-init-dir (expand-file-name ".emacs.d" tvd-win-home))
  (setq tvd-win-home nil))

;; all modes and extensions are located here
(setq tvd-lisp-dir (expand-file-name "lisp" user-init-dir))

;; --------------------------------------------------------------------------------
;; ** Shortcut Mode - mode specific help about my own customizations

;; FIXME: complete

(defun add-shortcut (mode help)
  (add-to-list 'shortcut-alist '(mode . help)))

(defun shortcut ()
  (interactive)
  (message (cdr (assoc major-mode 'shortcut-alist))))

;; --------------------------------------------------------------------------------
;; ** Fontlock-mode - use syntax highlighting on graphical displays

;; look: [[https://www.emacswiki.org/emacs/CustomizingBoth][emacswiki]]
(if window-system
    (progn
      (global-font-lock-mode 1)
      (set-background-color "white")
      (set-foreground-color "DarkBlue")))

;; --------------------------------------------------------------------------------
;; ** line-cursor in console

;; better visibility of cursor in console sessions
(unless (display-graphic-p)
  (global-hl-line-mode)
  (set-face-background hl-line-face "DarkGray")
  (set-face-foreground hl-line-face "Black"))

;; --------------------------------------------------------------------------------
;; ** Backup Config

;; I save backup files in a  central location below the init dir, that
;; way they don't clutter productive file systems or repos.

(setq tvd-backup-directory (expand-file-name "backups" user-init-dir))
(if (not (file-exists-p tvd-backup-directory))
    (make-directory tvd-backup-directory t))

;; there's even a trash
(setq tvd-trash-directory (expand-file-name "trash" tvd-backup-directory))


;; actual configuration of all things backup related:
(setq make-backup-files t               ; backup of a file the first time it is saved.
      backup-by-copying t               ; don't clobber symlinks
      version-control t                 ; version numbers for backup files
      delete-old-versions t             ; delete excess backup files silently
      delete-by-moving-to-trash t
      kept-old-versions 6               ; oldest versions to keep when a new numbered backup is made (default: 2)
      kept-new-versions 9               ; newest versions to keep when a new numbered backup is made (default: 2)
      auto-save-default t               ; auto-save every buffer that visits a file
      auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 200            ; number of keystrokes between auto-saves (default: 300)
      delete-by-moving-to-trash t
      trash-directory tvd-trash-directory
      backup-directory-alist `(("emacs.d/\\(recentf\\|ido.last\\|places\\)" . nil) ; do not backup state files
                               ("." . ,tvd-backup-directory))) ; backup everything else

;; However, if the file to be backed up is remote, backup
;; per remote directory. that way, no root owned files end
;; up in my home directory, ready to be read by everyone.
;; This is system specific and only matches special host names.
;; FIXME: find out programatically hostname und remote user to make this generic
(advice-add 'make-backup-file-name-1 :before
            '(lambda (&rest file)
               (let ((filename (car file)))
                 (if (string-match "\\(/ssh:.devel[0-9]+\\):/" filename)
                     (setq backup-directory-alist `(("." . ,(concat (match-string 1 filename) ":/root/.emacs.d/backups"))))
                   (setq backup-directory-alist `(("." . ,tvd-backup-directory)))))))

;; FIXME: and/or check [[https://www.gnu.org/software/tramp/#Auto_002dsave-and-Backup][gnu.org]]
;; + tramp-default-proxies-alist

;; --------------------------------------------------------------------------------
;; ** console backspace fix

;; make backspace work in console sessions
(define-key key-translation-map [?\C-h] [?\C-?])

;; --------------------------------------------------------------------------------
;; ** hide menu- and tool-bar

;; I prefer a bare bones emacs window without any distractions, so turn them off.
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq use-dialog-box nil)
(scroll-bar-mode 0)

;; --------------------------------------------------------------------------------
;; ** stay silent on startup

(setq initial-scratch-message "")
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message "scip")

;; --------------------------------------------------------------------------------
;; ** y means yes

;; y is shorter than yes and less error prone.
(defalias 'yes-or-no-p 'y-or-n-p)

;; --------------------------------------------------------------------------------
;; ** show col in modeline

;; very useful to know current column
(column-number-mode t)

;; --------------------------------------------------------------------------------
;; ** file or buffer in title

;; this can be seen in xmobar
(setq frame-title-format '(buffer-file-name "emacs %f" ("emacs %b")))


;; --------------------------------------------------------------------------------
;; ** avoid invalid files
(setq require-final-newline t)

;; --------------------------------------------------------------------------------
;; ** prepare load-path

;; where to look for extensions:
(add-to-list 'load-path tvd-lisp-dir)

(if (null tvd-win-home)
    (add-to-list 'load-path (expand-file-name "compat" tvd-lisp-dir)))

;; modules
(add-to-list 'load-path (concat tvd-lisp-dir "/er"))
(add-to-list 'load-path (concat tvd-lisp-dir "/org/lisp"))
(add-to-list 'load-path (concat tvd-lisp-dir "/ivy"))
(add-to-list 'load-path (concat tvd-lisp-dir "/doremi"))
(add-to-list 'load-path (concat tvd-lisp-dir "/org/contrib/lisp"))

;; --------------------------------------------------------------------------------
;; ** byte-compile all of them, if needed

;; handy function to recompile all lisp files
(defun recompile-el()
  (interactive)
  (byte-recompile-directory tvd-lisp-dir 0))

;; --------------------------------------------------------------------------------
;; ** increase fontsize with ctrl-+ and ctrl--

;; I use  those bindings everywhere  (firefox, terminal, etc),  and in
;; emacs as well.

(defun tvd-global-font-size-bigger ()
  "Make font size larger."
  (interactive)
  (text-scale-increase 0.5))

(defun tvd-global-font-size-smaller ()
  "Change font size back to original."
  (interactive)
  (text-scale-increase -0.5))

(global-set-key (kbd "C-+")             'tvd-global-font-size-bigger)    ; Schrift groesser
(global-set-key (kbd "C--")             'tvd-global-font-size-smaller)   ; kleiner

;; --------------------------------------------------------------------------------
;; ** WINDOW management stuff
;; *** resize windows by keyboard

;; Very practical: resize windows easily.

;; hit C-c C-r then use cursor keys to resize, <ret> to finish
(require 'windresize)
(global-set-key (kbd "C-c C-r")         'windresize)                                      ; Split Buffer Groesse Aendern

;; *** switch windows with MS-WINDOWS key
(require 'windmove)
(windmove-default-keybindings 'super)
(setq windmove-wrap-around t)

;; *** M-o switch window or buffer
;; via [[http://mbork.pl/2017-02-26_other-window-or-switch-buffer][mbork]]

;; Most of  the time I switch  back and forth between  two buffers, be
;; they  in separate  windows  or not.  With this  function  I can  do
;; that. Of course this doesn't work if there are more than 2 windows,
;; and it only works with the 2 most recent visited buffers.
(defun other-window-or-switch-buffer ()
  "Call `other-window' if more than one window is visible, switch
to next buffer otherwise."
  (interactive)
  (if (one-window-p)
      (switch-to-buffer nil)
    (other-window 1)))

(global-set-key (kbd "M-o")             'other-window-or-switch-buffer)

;; M-o doesn't  work when using emacs  via Win->RDP->VNC->X11->Xmonad,
;; so fall back to C-o.
(global-set-key (kbd "C-o")             'other-window-or-switch-buffer)

;; via
;; [[http://whattheemacsd.com/buffer-defuns.el-02.html][whattheemacs.d]]:
;; exchange left with right buffer (or up and down), love it.
(defun flip-windows ()
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

;; Use only in  X11 emacs - setting M-O inside console  causes <up> and
;; <down> to stop working properly, for whatever reasons.
(if (display-graphic-p)
(global-set-key (kbd "M-O")             'flip-windows))

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

;; ** re-read a modified buffer

;; F5 == reload file if it has been modified by another process, shift
;; because Xmonad
(global-set-key (kbd "S-<f5>")                                                            ; re-read a buffer from disk (revert)
                (lambda (&optional force-reverting)
                  "Interactive call to revert-buffer. Ignoring the auto-save
 file and not requesting for confirmation. When the current buffer
 is modified, the command refuses to revert it, unless you specify
 the optional argument: force-reverting to true."
                  (interactive "P")
                  ;;(message "force-reverting value is %s" force-reverting)
                  (if (or force-reverting (not (buffer-modified-p)))
                      (revert-buffer :ignore-auto :noconfirm)
                    (error "The buffer has been modified"))))


;; --------------------------------------------------------------------------------
;; ** global TAB/Indent config

;; I  use spaces  everywhere  but  Makefiles. If  I  encounter TABs  I
;; replace them with  spaces, if I encounter users  entering TABs into
;; files, I block them.

;; FIXME: also check [[https://github.com/glasserc/ethan-wspace][ethan-wspace]] !

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(setq tab-stop-list (quote (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120)))
(setq tab-always-indent 'complete) ; FIXME: doesnt work in cperl-mode
(setq show-trailing-whitespace t)

(defun indent-buffer ()
  ;; Author: Mathias Creutz
  "Re-Indent every line in the current buffer."
  (interactive)
  (indent-region (point-min) (point-max) nil))

;; Use normal tabs in makefiles
(add-hook 'makefile-mode-hook '(lambda() (setq indent-tabs-mode t)))


;; --------------------------------------------------------------------------------
;; ** handy aliases

;; M-x q r <ret> is short enough  for me, no need for key bindings for
;; those

(defalias 'qrr       'query-replace-regexp)
(defalias 'qr        'query-replace)
(defalias 'cr        'comment-region)
(defalias 'ur        'uncomment-region)
(defalias 'ir        'indent-region)
(defalias 'dv        'describe-variable)
(defalias 'dk        'describe-key)
(defalias 'df        'describe-function)
(defalias 'dp        'describe-char)
(defalias 'dm        'describe-mode)
(defalias 'db        'describe-bindings)
(defalias 'dl        'finder-commentary) ; aka "describe library"
(defalias 'repl      'ielm)
(defalias 'ws        'window-configuration-to-register) ; save window config
(defalias 'wr        'jump-to-register)                 ; restore window config
(defalias 'rec       'rectangle-mark-mode)
(defalias '|         'shell-command-on-region) ; apply shell command on region

;; --------------------------------------------------------------------------------
;; ** various settings

;; point stays while scrolling
(setq scroll-preserve-screen-position t)

;; no comment margins
(setq-default comment-column 0)

;; do not save until I hit C-x-s
(setq auto-save-default nil)

;; show all buffers in buffer menu
(setq buffers-menu-max-size nil)

;; start to wrap at 30 entries
(setq mouse-buffer-menu-mode-mult 30)

;; I'm grown up!
(setq disabled-command-function nil)

;; --------------------------------------------------------------------------------
;; ** load imenu
(define-key global-map [C-down-mouse-2] 'imenu)

;; --------------------------------------------------------------------------------
;; ** copy/paste Config

;; Related:
;; - see also mark-copy-yank-things-mode below!
;; - see also: move-region below (for M-<up|down>)
;; - see also: expand-region below (for C-0)

;; middle mouse button paste at click not where cursor is
(setq mouse-yank-at-point t)

;; highlight selected stuff (also allows DEL of active region)
(setq transient-mark-mode t)

;; pasting onto selection deletes it
(delete-selection-mode t)

;; delete whole lines
(setq kill-whole-line t)

;; middle-mouse and C-y use both X-selection and Emacs-clipboard
(if (null tvd-win-home)
    (progn  ; unix
      (setq x-select-enable-primary t)
      (setq x-select-enable-clipboard nil))
  (progn    ; win
    (global-set-key (kbd "<up-mouse-2>") 'yank)))

;; marked region automatically copied, also on win
(setq mouse-drag-copy-region t)

;; --------------------------------------------------------------------------------
;; ** use more mem
;; are you from the past?
(setq gc-cons-threshold 20000000)

;; --------------------------------------------------------------------------------
;; ** better file name completion

;; Complete filenames case insensitive and ignore certain files during completion.
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)

;; via [[http://endlessparentheses.com/improving-emacs-file-name-completion.html][endlessparantheses]]
(mapc (lambda (x)
        (add-to-list 'completion-ignored-extensions x))
      '(".aux" ".bbl" ".blg" ".exe"
        ".log" ".meta" ".out" ".pdf"
        ".synctex.gz" ".tdo" ".toc"
        "-pkg.el" "-autoloads.el" ".elc"
        ".dump" ".ps" ".png" ".jpg"
        ".gz" ".tgz" ".zip"
        "Notes.bib" "auto/"))

;; --------------------------------------------------------------------------------
;; ** abbreviations

;; Do I really need those anymore? Added ca 1999...

(define-abbrev-table 'global-abbrev-table '(
                                            ("oe" "&ouml;" nil 0)
                                            ("ue" "&uuml;" nil 0)
                                            ("ae" "&auml;" nil 0)
                                            ("Oe" "&Ouml;" nil 0)
                                            ("Ue" "&Uuml;" nil 0)
                                            ("Ae" "&Auml;" nil 0)
                                            ("<li>" "<li> </li>" nil 0)
                                            ("<ul>" "<ul> </ul>" nil 0)
                                            ))

;; do NOT ask to save abbrevs on exit
(setq save-abbrevs nil)

;; ** meaningful names for buffers with the same name

;; from ([[https://github.com/bbatsov/prelude][prelude]])

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

;; --------------------------------------------------------------------------------
;; ** packages

;; I dont need  it all the time and only  for experimentation, so lets
;; only use melpa on demand
(defun toggle-melpa()
  (interactive)
  (require 'package)
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.org/packages/"))
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
  (package-initialize)
  (list-packages))

;; --------------------------------------------------------------------------------
;; ** My own global variables

;; narrowed fringe background
(defvar tvd-fringe-narrow-bg "OrangeRed")

;; --------------------------------------------------------------------------------
;; ** More scratch space
;; *** Text scratch
;; Sometimes  I need  a  text  mode scratch  buffer  while scratch  is
;; already in use. So let's prepare one. I also add a buffer hook so that
;; this never gets deleted, but cleaned instead.

(with-current-buffer (get-buffer-create "*text*")
  (text-mode))

;; *** Autoscratch
;; use autoscratch otherwise
;; [[https://github.com/TLINDEN/autoscratch][autoscratch github]]
(require 'autoscratch-mode)
(setq initial-major-mode 'autoscratch-mode)
(add-hook 'autoscratch-mode-hook '(lambda ()
                                    (setq autoscratch-triggers-alist
                                          '(("[(;]"         . (progn
                                                                (emacs-lisp-mode)
                                                                (electric-indent-local-mode t)))
                                            ("#"            . (progn
                                                                (config-general-mode)
                                                                (electric-indent-local-mode t)))
                                            ("[-a-zA-Z0-9]" . (text-mode))
                                            ("/"            . (c-mode))
                                            ("*"            . (progn (insert " ") (org-mode)))
                                            ("."            . (fundamental-mode)))
                                          autoscratch-trigger-on-first-char t
                                          autoscratch-reset-default-directory t)
                                    (electric-indent-local-mode nil)
                                    ))
(defalias 'scratch 'autoscratch-buffer)

;; *** Persistent Scratch
;; I also like to be scratch buffers persistent with
;; [[https://github.com/Fanael/persistent-scratch][persistent-scratch]]
(require 'persistent-scratch)
(setq persistent-scratch-save-file (expand-file-name "scratches.el" user-init-dir))
(persistent-scratch-setup-default)

(defun tvd-autoscratch-p ()
  "Return non-nil if the current buffer is a scratch buffer"
  (string-match "scratch*" (buffer-name)))

(setq persistent-scratch-scratch-buffer-p-function 'tvd-autoscratch-p)

;; ** Recenter config

;; [[http://oremacs.com/2015/03/28/recenter/][via abo abo]]

;; However, I set the first position  to 1, which causes the window to
;; be recentered on the second line, that is, I can see one line above
;; the current one. It works the same with bottom, which I intend, but
;; I think this is a recenter calculation bug.

(setq recenter-positions '(1 middle bottom))

;; * Global Key Bindings
;; --------------------------------------------------------------------------------
;; ** c-h != delete
(keyboard-translate ?\C-h ?\C-?)
(keyboard-translate ?\C-? ?\C-h)

;; --------------------------------------------------------------------------------
;; ** general keys (re-)mappings
;(global-set-key (kbd "C-s")             'isearch-forward-regexp)
;(global-set-key (kbd "C-r")             'isearch-backward-regexp)
(global-set-key (kbd "M-C-s")           'isearch-forward)
(global-set-key (kbd "M-C-r")           'isearch-backward)
(global-set-key (kbd "M-%")             'query-replace-regexp)
(global-set-key (kbd "<backtab>")       'dabbrev-completion)                              ; shift-tab, inline completion

(global-set-key (kbd "<f9>")            'html-mode)
(global-set-key (kbd "<delete>")        'delete-char)                                     ; Entf            Char loeschen
(global-set-key (kbd "<backspace>")     'backward-delete-char)                            ; Shift+Backspace dito
(global-set-key (kbd "S-<delete>")      'kill-word)                                       ; Shift+Entf      Wort loeschen
(global-set-key (kbd "S-<backspace>")   'backward-kill-word)                              ; Shift+Backspace dito
(global-set-key (kbd "C-<delete>")      'kill-word)                                       ; Shift+Entf      dito
(global-set-key (kbd "C-<backspace>")   'backward-kill-word)                              ; Shift+Backspace dito
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-x k")           'kill-this-buffer)                                ; C-x k  really kill current buffer w/o asking
(global-set-key (kbd "C-x C-b")         'buffer-menu)



;; --------------------------------------------------------------------------------
;; ** display a list of my own global key bindings and aliases
;; via [[https://www.emacswiki.org/emacs/OccurMode#toc9][emacswiki]]

;; Inside *Occur*: q - quit, e - edit, g - reload
;; more help with: describe-function occur-mode

(defun occur-mode-clean-buffer ()
  "Removes all commentary from the *Occur* buffer, leaving the
 unadorned lines."
  (interactive)
  (if (get-buffer "*Occur*")
      (save-excursion
        (set-buffer (get-buffer "*Occur*"))
        (goto-char (point-min))
        (toggle-read-only 0)
        (if (looking-at "^[0-9]+ lines matching \"")
            (kill-line 1))
        (while (re-search-forward "^[ \t]*[0-9]+:"
                                  (point-max)
                                  t)
          (replace-match "")
          (forward-line 1)))
    (message "There is no buffer named \"*Occur*\".")))

(defun show-definition(REGEX)
  (interactive)
  (let ((dotemacs-loaded nil)
        (occur-b "*Occur*")
        (occur-c ""))
    (if (get-buffer ".emacs")
        (progn
          (switch-to-buffer ".emacs")
          (setq dotemacs-loaded t))
      (find-file "~/.emacs"))
    (occur REGEX)
    (with-current-buffer occur-b
      (occur-mode-clean-buffer)
      (setq occur-c (current-buffer))
      (let ((inhibit-read-only t)) (set-text-properties (point-min) (point-max) ()))
      (while (re-search-forward "[0-9]*:" nil t)
        (replace-match ""))
      (beginning-of-buffer)
      (kill-line)
      (sort-lines nil (point-min) (point-max))
      (emacs-lisp-mode)
      (beginning-of-buffer)
      (insert (format ";; *SHOW*:   %s\n" REGEX))
      (highlight-regexp REGEX)
      (beginning-of-buffer))
    (switch-to-buffer occur-b)
    (delete-other-windows)
    (if (eq dotemacs-loaded nil)
        (kill-buffer ".emacs"))))

(defun show-keys()
  (interactive)
  (show-definition "^(global-set-key"))

(defun show-aliases()
  (interactive)
  (show-definition "^(defalias"))

(defalias 'sk        'show-keys)
(defalias 'sa        'show-aliases)

;; --------------------------------------------------------------------------------
;; * Productivity Functions
;; --------------------------------------------------------------------------------
;; ** goto line with tmp line numbers

;; I stole this somewhere, as far as I remember, emacswiki, however, I
;; always had F7 for goto-line

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (call-interactively 'goto-line))
    (linum-mode -1)))

(global-set-key (kbd "<f7>")            'goto-line-with-feedback)

;; --------------------------------------------------------------------------------
;; ** invert fore- and background

;; Sometimes when  sitting in a  very dark enviroment, my  usual light
;; emacs frame is  a too stark contrast to the  environment. With this
;; function  I can  just  invert  my current  color  settings to  dark
;; background and light foreground.

;; remember last inverse
(defvar tvd-invert-state t)

;; invert everything, reverse it when called again
(defun tvd-invert()
  "invert fg-bg"
  (interactive)
  (invert-face 'default)
  (invert-face 'mode-line)
  (set-face-attribute 'fringe nil :inverse-video tvd-invert-state)
  (setq tvd-invert-state (not tvd-invert-state)) ;; cycle variable tvd-invert-state
  )

;; fast
(global-set-key (kbd "C-c C-i")           'tvd-invert)

;; --------------------------------------------------------------------------------
;; ** Some useful bindings  for Home and End keys Hit  the key once to

;; Go to the beginning/end  of a line, hit it twice in a  row to go to
;; the beginning/end of  the window, three times in a  row goes to the
;; beginning/end of the buffer.  NB that there is no timeout involved.

;; Uses a function of viking-mode to establish key repeats, see below.

(defun pc-keys-home ()
  "Go to beginning of  line/window/buffer. First hitting key goes
to  beginning of  line,  second in  a row  goes  to beginning  of
window, third in a row goes to beginning of buffer."
  (interactive)
  (let* ((key-times (viking-last-key-repeats)))
    (cond
     ((eq key-times 3)
      (if mark-active
          (goto-char (point-min))
        (beginning-of-buffer)))
     ((eq key-times 2)
      (if mark-active () (push-mark))
      (move-to-window-line 0))
     ((eq key-times 1)
      (beginning-of-line)))))

(defun pc-keys-end ()
  "Go to end of  line/window/buffer. First hitting key goes
to end  of line, second  in a  row goes to  end of
window, third in a row goes to end of buffer."
  (interactive)
  (let* ((key-times (viking-last-key-repeats)))
    (cond
     ((eq key-times 3)
      (if mark-active
          (goto-char (point-max))
        (end-of-buffer)))
     ((eq key-times 2)
      (if mark-active () (push-mark))
      (move-to-window-line -1)
      (end-of-line))
     ((eq key-times 1)
      (end-of-line)))))

;; This is the most natural use for those keys
(global-set-key (kbd "<home>")          'pc-keys-home)
(global-set-key (kbd "<end>")           'pc-keys-end)



;; --------------------------------------------------------------------------------
;; ** percent function
;; by Jens Heunemann: jump to percent position into current buffer

(defun goto-percent (p)                        ;goto Prozentwert (0-100): F8
  (interactive "nProzent: ")
  (if (> (point-max) 80000)
      (goto-char (* (/ (point-max) 100) p))    ;Ueberlauf vermeiden: (max/100)*p
    (goto-char (/ (* p (point-max)) 100)))     ;Rundungsfehler verm.: (max*p)/100
  (beginning-of-line))

(global-set-key (kbd "<f8>")            'goto-percent)                                    ;F8 goto percent

;; --------------------------------------------------------------------------------
;; ** Simulate vi's % function

;; There's not  a lot  about vi[m]  I like,  but jumping  with %  to a
;; matching paren is one of THOSE features, I also need in emacs.

;; with ideas from [[https://www.emacswiki.org/emacs/NavigatingParentheses#toc2][emacswiki]]

;; If (point)  is on a paren,  jump to the matching  paren, otherwise,
;; just insert a literal ?%. Only make sense if bound to %.

(defun jump-paren-match-or-insert-percent (arg)
  "Go to  the matching  parenthesis if on  parenthesis. Otherwise
insert %. Mimics vi style of % jumping to matching brace."
  (interactive "p")
  (cond ((looking-at "\\s\(\\|\{\\|\\[") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)\\|\}\\|\\]") (forward-char 1) (backward-list 1))
        (t (insert "%"))))

(global-set-key (kbd "%")               'jump-paren-match-or-insert-percent)

;; --------------------------------------------------------------------------------
;; ** Move region

;; Mark a region, then use M-up|down to move it around
;; via [[https://www.emacswiki.org/emacs/MoveRegion][emacswiki]]
;; code from [[https://github.com/targzeta/move-lines/blob/master/move-lines.el][move-lines]]

(defun move-lines--internal (n)
  (let* ((start (point)) ;; The position of beginning of line of the first line
         (end start)     ;; The position of eol+\n of the end line
         col-init        ;; The current column for the first line
         (col-end (current-column)) ;; The current column for the end line
         exchange_pm     ;; If I had exchanged point and mark
         delete-latest-newline) ;; If I had inserted a newline at the end

    ;; STEP 1: Identifying the line(s) to cut.
    ;; ---
    ;; If region is actives, I ensure that point always is at the end of the
    ;; region and mark at the beginning.
    (when (region-active-p)
      (when (< (point) (mark))
        (setq exchange_pm t)
        (exchange-point-and-mark))
      (setq start (mark)
            end (point)
            col-end (current-column)))

    (goto-char start) (setq col-init (current-column))
    (beginning-of-line) (setq start (point))

    (goto-char end) (end-of-line)
    ;; If point == point-max, this buffers doesn't have the trailing newline.
    ;; In this case I have to insert a newline otherwise the following
    ;; `forward-char' (to keep the "\n") will fail.
    (when (= (point) (point-max))
      (setq delete-latest-newline t)
      (insert-char ?\n) (forward-char -1))
    (forward-char 1) (setq end (point))

    ;; STEP 2: Moving the lines.
    ;; ---
    ;; The region I'm cutting span from the beginning of line of the current
    ;; line (or current region) to the end of line + 1 (newline) of the current
    ;; line (or current region).
    (let ((line-text (delete-and-extract-region start end)))
      (forward-line n)
      ;; If the current-column != 0, I have moved the region at the bottom of a
      ;; buffer doesn't have the trailing newline.
      (when (not (= (current-column) 0))
        (insert-char ?\n)
        (setq delete-latest-newline t))
      (setq start (+ (point) col-init)) ;; Now, start is the start of new region
      (insert line-text))

    ;; STEP 3: Restoring
    ;; ---
    ;; I'm at the end of new region (or line) and start has setted at the
    ;; beginning of new region (if a region is active).
    ;; Restoring the end column.
    (forward-line -1)
    (forward-char col-end)

    (when delete-latest-newline
      (save-excursion
        (goto-char (point-max))
        (delete-char -1)))

    (when (region-active-p)
      (setq deactivate-mark nil)
      (set-mark start)
      (if exchange_pm
          (exchange-point-and-mark)))))

(defun move-lines-up (n)
  "Moves the current line or, if region is actives, the lines surrounding
region, up by N lines, or 1 line if N is nil."
  (interactive "p")
  (if (eq n nil)
      (setq n 1))
  (move-lines--internal (- n)))

(defun move-lines-down (n)
  "Moves the current line or, if region is actives, the lines surrounding
region, down by N lines, or 1 line if N is nil."
  (interactive "p")
  (if (eq n nil)
      (setq n 1))
  (move-lines--internal n))

(global-set-key (kbd "M-<up>")          'move-lines-up)
(global-set-key (kbd "M-<down>")        'move-lines-down)

;; --------------------------------------------------------------------------------
;; ** comment-uncomment region with one key binding
;; via [[http://stackoverflow.com/a/9697222/3350881][stackoverflow]]
(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))

(global-set-key (kbd "C-c C-c")         'comment-or-uncomment-region-or-line)

;; --------------------------------------------------------------------------------
;; ** search for symbol at point

;; Simulate the # function of vi,  marks the symbol at point, C-s then
;; searches for it. I use this a lot.

;; via [[http://ergoemacs.org/emacs/modernization_isearch.html][ergomacs]]

(defun xah-search-current-word ()
  "Call `isearch' on current word or text selection.
   'word' here is A to Z, a to z, and hyphen and underline, independent of syntax table.
URL `[[http://ergoemacs.org/emacs/modernization_isearch.html'][ergomacs]]
Version 2015-04-09"
  (interactive)
  (let ( xahp1 xahp2 )
    (if (use-region-p)
        (progn
          (setq xahp1 (region-beginning))
          (setq xahp2 (region-end)))
      (save-excursion
        (skip-chars-backward "-_A-Za-z0-9")
        (setq xahp1 (point))
        (right-char)
        (skip-chars-forward "-_A-Za-z0-9")
        (setq xahp2 (point))))
    (setq mark-active nil)
    (when (< xahp1 (point))
      (goto-char xahp1))
    (isearch-mode t)
    (isearch-yank-string (buffer-substring-no-properties xahp1 xahp2))
    (message "Now use C-s to search for it ...")
    ))

(global-set-key (kbd "C-#")             'xah-search-current-word)

;; --------------------------------------------------------------------------------
;; ** Window Margin

;; Kinda screen reader  for the poor.  I use this  sometimes with info
;; or woman mode. I also use a full featured screen reader: nove-mode,
;; see below.

;; left+right margin on demand (but nothing else)
(defun margin(m)
  "set left and right margins for better readability"
  (interactive "nEnter Margin (0 to disable) [0-9]+: ")
  (set-window-margins (car (get-buffer-window-list (current-buffer) nil t)) m m) ;; set immediately
  (setq left-margin-width m) ;; persist until reset
  (setq right-margin-width m)
  (message "To reset, change Buffer or call again with arg 0.")
  )

;; --------------------------------------------------------------------------------
;; ** Fill and justify a paragraph

;; this is just a shortcut for:
;;    C-u 70 <ret> M-x fill-paragraph
;; but C-q is just easier to remember

;; however, if pressed again it un-fills the paragraph,
;; idea via: [[http://endlessparentheses.com/fill-and-unfill-paragraphs-with-a-single-key.html][endlessparentheses]]
(defun tvd-fill-and-justify-or-unfill()
  (interactive)
  (let ((fill-column
         (if (eq last-command 'tvd-fill-and-justify-or-unfill)
             (progn (setq this-command nil)
                    (point-max))
           fill-column)))
    (fill-paragraph 70)))

(global-set-key (kbd "C-q")             'tvd-fill-and-justify-or-unfill)                   ; like M-q, which is bound to x-window-quit in xmonad: fill+justify

;; --------------------------------------------------------------------------------
;; ** Make a read-only copy of the current buffer

;; I just create  a new read-only buffer and copy  the contents of the
;; current one  into it, which  can be used as  backup. I use  this in
;; cases where I need to re-factor a file and do lots of changes. With
;; the buffer copy  I have a reference to compare  without the need to
;; leave emacs and look at revision  control diffs or the like, and if
;; a file is not maintained via VC anyway.

(defvar copy-counter 0)

(defun get-copy-buffer-name()
  "return unique copy buffer name"
  (let ((name (concat "*COPY " (buffer-name (current-buffer)) " (RO)")))
    (if (not (get-buffer name))
        (progn
          (setq copy-counter (1+ copy-counter))
          (concat name "<" (number-to-string copy-counter) ">"))
      (concat name))))

(defun copy-buffer-read-only()
  "Create a read-only copy of the current buffer"
  (interactive)
  (let ((old-buffer (current-buffer))
        (new-buffer-name (get-copy-buffer-name)))
    (progn
      (delete-other-windows)
      (split-window-horizontally)
      (other-window 1)
      (if (not (eq (get-buffer new-buffer-name) nil))
          (kill-buffer (get-buffer new-buffer-name)))
      (set-buffer (get-buffer-create new-buffer-name))
      (insert-buffer-substring old-buffer)
      (read-only-mode)
      (switch-to-buffer new-buffer-name)
      (other-window 1))))

(defalias 'cp        'copy-buffer-read-only)

(global-set-key (kbd "C-c C-p")         'copy-buffer-read-only)                           ; make read-only buffer copy

;; --------------------------------------------------------------------------------
;; ** Cleanup, close all windows and kill all buffers

;; From  time  to  time  I  get annoyed  by  the  many  dozen  buffers
;; opened. In such cases I like to close them all at once.

;; No key binding though,  just in case I stumble upon  it and kill my
;; setup accidentally.

(defun kill-all-buffers ()
  "Kill all buffers, clean up, close all windows"
  (interactive)
  (when (y-or-n-p "Close all windows and kill all buffers?")
    (delete-other-windows)
    (clean-buffer-list)
    (dolist (buffer (buffer-list))
      (kill-buffer buffer))
    (delete-minibuffer-contents)
    (if (fboundp 'tramp-cleanup-all-connections)
        (tramp-cleanup-all-connections))
    (with-current-buffer (get-buffer-create "*text*")
      (text-mode))
    (autoscratch-buffer)))

;; --------------------------------------------------------------------------------
;; ** Cleanup current buffer

;; Remove TABs, leading and trailing spaces, re-indent a buffer.

;; via [[http://whattheemacsd.com/buffer-defuns.el-01.html][whattheemacs.d]]

(defun cleanup-buffer ()
  "Perform a bunch of safe operations on the whitespace content of a buffer.
Does not indent buffer, because it is used for a before-save-hook, and that
might be bad."
  (interactive)
  (untabify (point-min) (point-max))
  (delete-trailing-whitespace)
  (save-excursion
    (replace-regexp "^\n\\{3,\\}" "\n\n" nil (point-min) (point-max)))
  (set-buffer-file-coding-system 'utf-8)
  (indent-region (point-min) (point-max)))

(defalias 'cb        'cleanup-buffer)

;; --------------------------------------------------------------------------------
;; ** Remove Umlauts and other crab in current buffer

;; converts:
;;            Stan Lem - ein schönes Leben & sonst nix(ungekuerzte Ausgabe)
;; to:
;;            Stan_Lem-ein_schoenes_Leben_sonst_nix_ungekuerzte_Ausgabe
;;
;; used in dired buffers to cleanup filenames by german windows users.
(defun umlaute-weg()
  (interactive)
  (let ((umlaute '((Ü . Ue)
                   (Ä . Ae)
                   (Ö . Oe)
                   (ü . ue)
                   (ä . ae)
                   (ö . oe)
                   (ß . ss)))
        (regs (list
               '(" "       . "_")
               '("_-_"     . "-")
               '("[\(\)&]" . "_")
               '("__*"     . "_")
               '("_$"      . "")
               )))
    (save-excursion
      (dolist (pair umlaute)
        (replace-regexp (symbol-name (car pair))
                        (symbol-name (cdr pair))
                        nil
                        (point-min) (point-max)))
      (dolist (reg regs)
        (replace-regexp (car reg) (cdr reg) nil
                        (point-min) (point-max))))))

;; --------------------------------------------------------------------------------
;; ** Better newline(s)

;; Add newline  and jump to indent  from wherever I am  in the current
;; line, that is it is not required to be on the end of line.

;; via [[http://whattheemacsd.com/editing-defuns.el-01.html][whattheemacs.d]]

(defun open-line-below ()
  (interactive)
  (end-of-line)
  (newline)
  (indent-for-tab-command))

(defun open-line-above ()
  (interactive)
  (end-of-line)
  (beginning-of-line)
  (newline)
  (forward-line -1)
  (indent-for-tab-command))

;; disabled, interferes with modes.

;; (global-set-key (kbd "<C-return>")      'open-line-below)

;; (global-set-key (kbd "<C-S-return>")    'open-line-above)

;; --------------------------------------------------------------------------------
;; ** Mouse Rectangle

;; There's not  much use for  the mouse in  emacs, but this  gimick is
;; funny and works like a charm.

;; via [[http://emacs.stackexchange.com/a/7261][stackoverflow]]
(defun mouse-start-rectangle (start-event)
  (interactive "e")
  (deactivate-mark)
  (mouse-set-point start-event)
  (rectangle-mark-mode +1)
  (let ((drag-event))
    (track-mouse
      (while (progn
               (setq drag-event (read-event))
               (mouse-movement-p drag-event))
        (mouse-set-point drag-event)))))

(global-set-key (kbd "S-<down-mouse-1>") 'mouse-start-rectangle)

;; --------------------------------------------------------------------------------
;; ** DOS <=> UNIX conversion helpers

(defun dos2unix ()
  (interactive)
  (set-buffer-file-coding-system 'utf-8-unix)
  (message (format "converted current buffer to %s" buffer-file-coding-system)))

(defun unix2dos ()
  (interactive)
  (set-buffer-file-coding-system 'utf-8-dos)
  (message (format "converted current buffer to %s" buffer-file-coding-system)))
;; --------------------------------------------------------------------------------
;; ** helper do add the same thing to multiple mode hooks
;; via [[http://stackoverflow.com/posts/3900056/revisions][stackoverflow]]
;; usage samples below.
(defun add-something-to-mode-hooks (mode-list something)
  "helper function to add a callback to multiple hooks"
  (dolist (mode mode-list)
    (add-hook (intern (concat (symbol-name mode) "-mode-hook")) something)))

;; --------------------------------------------------------------------------------

;; ** helper to catch load errors

;; Try to  eval 'fn,  catch errors,  if any but  make it  possible for
;; emacs to continue undisturbed, used with SMEX, see below.
(defmacro safe-wrap (fn &rest clean-up)
  `(unwind-protect
       (let (retval)
         (condition-case ex
             (setq retval (progn ,fn))
           ('error
            (message (format "Caught exception: [%s]" ex))
            (setq retval (cons 'exception (list ex)))))
         retval)
     ,@clean-up))
;; --------------------------------------------------------------------------------
;; ** Alignment Wrappers

;; align-regexp is already  a very usefull tool,  however, sometimes I
;; want  to repeat  the alignment  and I  hate C-u,  so here  are some
;; wrappers to make this easier.

(defun align-repeat (regex &optional alignment)
  "Aply  REGEX  to all  columns  not  just  the first.  Align  by
ALIGNMENT which must be 'left or 'right. The default is 'left.

Right alignment:

col1 ,col2
col1 ,col2

Left alignment:

col1, col2
col1, col2"
  (interactive  "MRepeat Align Regex [ ]: ")
  (let ((spc " ")
        (beg (point-min))
        (end (point-max))
        (areg "%s\\(\\s-*\\)" ; default left aligned
              ))
    (when (string= regex "")
      (setq regex spc))
    (when (region-active-p)
      (setq beg (region-beginning))
      (setq end (region-end)))
    (when (eq alignment 'right)
        (setq areg "\\(\\s-*\\)%s"))
    (align-regexp beg end (format areg regex) 1 1 t)))

(defun align-repeat-left (regex)
  (interactive  "MRepeat Left Align Regex [ ]: ")
  (align-regexp-repeat regex 'left))

(defun align-repeat-right (regex)
  (interactive  "MRepeat Left Align Regex [ ]: ")
  (align-regexp-repeat regex 'right))


;; ** String Helpers

;; Some helper functions I use here and there.

(defun tvd-alist-keys (A)
  "return a list of keys of alist A"
  (let ((K ()))
    (dolist (e A)
            (push (car e) K)
            )
    K))

(defun tvd-get-line ()
  "return current line in current buffer"
  (buffer-substring-no-properties
   (line-beginning-position)
   (line-end-position)))

(defun tvd-starts-with (s begins)
  "Return non-nil if string S starts with BEGINS."
  (cond ((>= (length s) (length begins))
         (string-equal (substring s 0 (length begins)) begins))
        (t nil)))

(defun tvd-replace-all (regex replace) 
  "Replace all matches of REGEX with REPLACE in current buffer."
  (interactive)
  (goto-char (point-min))
  (while (re-search-forward regex (end-of-line) t)
    (replace-match replace)))

;; * Modes
;; ** Programming Languages
;; *** VALA

(autoload 'vala-mode "vala-mode" "Major mode for editing Vala code." t)
(add-to-list 'auto-mode-alist '("\\.vala$" . vala-mode))
(add-to-list 'auto-mode-alist '("\\.vapi$" . vala-mode))
(add-to-list 'file-coding-system-alist '("\\.vala$" . utf-8))
(add-to-list 'file-coding-system-alist '("\\.vapi$" . utf-8))

;; --------------------------------------------------------------------------------

;; *** python mode

;; Not much configured for python, I'm happy with the defaults as it seems :)
(require 'python)
(autoload 'python-mode "python-mode" "Major mode for python scripts" t)

(add-hook
 'python-mode-hook
 (function
  (lambda()
    (local-set-key  [delete] 'py-electric-delete)
    (setq-default indent-tabs-mode nil)
    (setq mode-name "PY")
    (outline-minor-mode 0) ;; turn off outline here. FIXME: find out where it's turned on!
    )))

(setq auto-mode-alist
      (append '(("\\.\\(py\\)$"  . python-mode))
              auto-mode-alist))
;; --------------------------------------------------------------------------------

;; *** cperl mode

;; I am  a perl addict. I  love it, therefore, emacs  must be prepared
;; for my addiction.  Most importantly,  I prefer cperl instead of the
;; default perl  mode. I do not  use the cperl version  delivered with
;; emacs though, but the latest git version.

(autoload 'cperl-mode "cperl-mode" "alternate perl mode" t)
(defalias 'perl-mode 'cperl-mode)

;; enable the most important cperl features
(setq cperl-indent-left-aligned-comments nil)
(setq cperl-comment-column 32)
(setq cperl-hairy t)
(setq cperl-electric-linefeed t)
(setq cperl-electric-keywords t)
(setq cperl-electric-parens t)
(setq cperl-electric-parens-string nil)

;; perl special: run, compile, debug
(setq perl-run-out-buffer "*Async Shell Command*")

(defun perl-kill ()
  "get rid of hanging perl compile or run buffers"
  (interactive)
  (delete-windows-on perl-run-out-buffer)
  (kill-buffer perl-run-out-buffer))

(defun perl-run (switches parameters prefix)
  "execute current perl buffer"
  (interactive "sPerl-switches:\nsParameter:\nP")
  (let ((file buffer-file-name))
    (if (eq prefix nil)
        (shell-command (concat "perl " switches " " file " " parameters "&"))
      (shell-command (concat "perl -wc " switches " " file " " parameters "&")))
    (save-excursion
      (set-buffer perl-run-out-buffer)
      (setq perl-error-fontified nil
            perl-error-start nil
            perl-error-end nil)
      (goto-char (point-min)))
    ))

(defun perl-next-error ()
  "jump to next perl run error, if any"
  (interactive)
  (let (line
        errorfile
        (window (get-buffer-window (buffer-name)))
        (file buffer-file-name)
        (buffer (buffer-name))
        )
    (select-window (display-buffer perl-run-out-buffer))
    (set-buffer perl-run-out-buffer)
    (if (eq perl-error-fontified t)
        (progn
          (set-text-properties perl-error-start perl-error-end ())
          (setq perl-error-fontified nil)
          )
      )
    (if (re-search-forward (concat "at \\([-a-zA-Z:0-9._~#/\\]*\\) line \\([0-9]*\\)[.,]") (point-max) t)
        ()
      (goto-char (point-min))
      (message "LAST ERROR, jumping to first")
      (re-search-forward (concat "at \\([-a-zA-Z:0-9._~#/\\]*\\) line \\([0-9]*\\)[.,]") (point-max) t)
      )
    (recenter)
    (set-text-properties (match-beginning 1)
                         (match-end 2)
                         (list 'face font-lock-keyword-face))
    (setq perl-error-fontified t
          perl-error-start (match-beginning 1)
          perl-error-end (match-end 2)
          errorfile (buffer-substring
                     (match-beginning 1)
                     (match-end 1))
          line (string-to-int (buffer-substring
                               (match-beginning 2)
                               (match-end 2))))
    (select-window window)
    (find-file errorfile)
    (goto-line line)))

;; cperl indent region
(defun own-cperl-indent-region-or-paragraph (start end)
  (interactive "r")
  (if mark-active
      (cperl-indent-region start end)
    (save-excursion
      (mark-paragraph)
      (cperl-indent-region (point) (mark t))
      )))

;; and hook them into cperl
(add-hook
 'cperl-mode-hook
 (function
  (lambda()
    (make-variable-buffer-local 'perl-error-fontified)
    (make-variable-buffer-local 'perl-error-start)
    (make-variable-buffer-local 'perl-error-end)
    (make-variable-buffer-local 'perl-old-switches)
    (make-variable-buffer-local 'perl-old-parameters)
    (local-set-key "\C-hF" 'cperl-info-on-current-command)
    (local-set-key "\C-hf" 'describe-function)
    (local-set-key "\C-hV" 'cperl-get-help)
    (local-set-key "\C-hv" 'describe-variable)
    (local-set-key "\C-cr" 'perl-run)
    (local-set-key [f5]          'perl-run)             ;F5 perl-run
    (local-set-key [f6]          'perl-kill)            ;F6 perl-kill
    (local-set-key "\C-ck" 'perl-kill)
    (local-set-key "\C-c#" 'perl-next-error)
    (local-set-key "\M-\C-q" 'own-cperl-indent-region-or-paragraph)
    (setq mode-name "PL")
    )))



;; --------------------------------------------------------------------------------

;; *** Paredit for lisp only

;; I use paredit in lisp a lot, but are mostly happy with the defaults.

(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)

;; However, I use it with lisp dialects only
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1)))

;; sometimes I need to be able to turn it off fast:
(defalias 'pe        'paredit-mode)

(eval-after-load 'paredit
  '(progn
     ;; force my own bindings for those
     (define-key paredit-mode-map (kbd "C-d") nil)
     (define-key paredit-mode-map (kbd "<M-up>") nil)
     (define-key paredit-mode-map (kbd "<M-down>") nil)))
;; --------------------------------------------------------------------------------

;; *** ETAGS

;; I use ETAGS for some projects. With  etags I can easily jump to the
;; definition  of a  function,  struct or  whatever  across files  and
;; directories.

;; manually generate the tags file:
;; /usr/bin/ctags-exuberant -e *.c ...
;; visit-tags-file ("TAGS" whereever ctags run)

;; then load TAGS with visit-tags-table
(require 'etags-select)

;; generate TAGS and load it
(defun etags-create (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (let* ((ctags "/usr/bin/ctags-exuberant")
         (odir  (directory-file-name dir-name))
         (ofile (concat odir "/TAGS"))
         (langs "lisp,python,perl,c,c++,shell")
         (shell-command
          (format "%s -f %s -e -R --languages=%s %s" ctags ofile langs odir))
         (visit-tags-table ofile))))

;; ALT_R + e (equals on de keyboard € sign): jump to tag source
(global-set-key (kbd "€")               'etags-select-find-tag-at-point)                  ; alt-right + e: jump to tag definition

;; Use ido to list tags, but then select via etags-select (best of both worlds!)
(defun etags-find ()
  "Find a tag using ido"
  (interactive)
  (tags-completion-table)
  (let (tag-names)
    (mapatoms (lambda (x)
                (push (prin1-to-string x t) tag-names))
              tags-completion-table)
    (etags-select-find (ido-completing-read "Tag: " tag-names))))

;; some handy aliases
(defalias 'ec        'etags-create)
(defalias 'ef        'etags-find)

;; --------------------------------------------------------------------------------

;; ** Text Modes
;; *** sgml

;; Used for XML and the likes.

(setq sgml-set-face t)
(setq sgml-balanced-tag-edit t)
(setq sgml-omittag-transparent nil)
(setq sgml-auto-insert-required-elements t)

(setq sgml-markup-faces
      '((start-tag . font-lock-function-name-face)
        (end-tag . font-lock-function-name-face)
        (comment . font-lock-comment-face)
        (pi . font-lock-other-type-face)
        (sgml . font-lock-variable-name-face)
        (doctype . font-lock-type-face)
        (entity . font-lock-string-face)
        (shortref . font-lock-keyword-face)))
;; --------------------------------------------------------------------------------

;; *** web-mode (JS, HTML, CSS combined)

;; Web development is shit. Tech involved is a mess, and in most cases
;; intermixed.  web-mode provides  a great  fix for  this: it  handles
;; HTML, CSS and Javascript in the same buffer very well.

;; See: [[http://web-mode.org/][web-mode.org]]

(require 'web-mode)

;; associate with the usual suspects
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; configure web mode
(defun tvd-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-style-padding 1)
  (setq web-mode-script-padding 1)
  (setq web-mode-block-padding 0)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-auto-expanding t))
(add-hook 'web-mode-hook  'tvd-web-mode-hook)

;; some handy html code inserters
(defun html-insert-p()
  (interactive)
  (web-mode-element-wrap "p"))

(defun html-insert-li()
  (interactive)
  (web-mode-element-wrap "li"))

(defun html-insert-ul()
  (interactive)
  (web-mode-element-wrap "ul"))

(defun html-insert-b()
  (interactive)
  (web-mode-element-wrap "b"))

;; convert a text list into a html list.
(defun html-listify (beg end)
  (interactive "r")
  (save-excursion
    (let* ((lines (split-string (buffer-substring beg end) "\n" t)))
      (delete-region beg end)
      (insert "<ul>\n")
      (while lines
        (insert "  <li>")
        (insert (pop lines))
        (insert "</li>\n"))
      (insert "</ul>\n")
      )))
;; --------------------------------------------------------------------------------

;; *** Cisco Mode

;; Written by myself  many years ago, but I'm still  using it daily to
;; view and prepare cisco configs.

(autoload 'cisco-mode "cisco-mode" "Major mode for CISCO configs" t)
(setq auto-mode-alist
      (append '(("\\.\\(cfg\\)$"  . cisco-mode))
              auto-mode-alist))
;; --------------------------------------------------------------------------------

;; *** Markdown

;; I rarely use markdown, but sometimes I stumble upon such a file and
;; like    to    view    it     with    emacs    without    rendering.
;; Source: [[http://jblevins.org/projects/markdown-mode/][jblevins.org]]

(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)

(add-to-list 'auto-mode-alist '("\\.text\\'"     . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'"       . markdown-mode))

;; parens and quotes constraints check on save
(add-hook 'markdown-mode-hook
          (lambda ()
            (when buffer-file-name
              (add-hook 'after-save-hook
                        'check-parens
                        nil t))
            (modify-syntax-entry ?\" "\"" markdown-mode-syntax-table)
            ))
;; --------------------------------------------------------------------------------

;; *** POD mode

;; I LOVE POD!  POD is the  documentation format of perl and there's a
;; solid toolset available for it. I use it to write documentation and
;; manual pages. It's  much more powerfull than lame  markdown and you
;; can even program  great tools yourself around POD (like  I did with
;; PodWiki years ago!)

;; Although cperl mode  already has some POD support, pod  mode is way
;; better.

;; Source: [[https://github.com/renormalist/emacs-pod-mode][emacs-pod-mode]]

(require 'pod-mode)
(add-to-list 'auto-mode-alist '("\\.pod$" . pod-mode))
(add-hook 'pod-mode-hook 'font-lock-mode)

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
                   (delete-char 1)))))

;; pod mode config
(add-hook 'pod-mode-hook
          (lambda ()
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
            (local-set-key (kbd "C-c c") 'pod-code)))

;; --------------------------------------------------------------------------------
;; *** conf-mode

;; conf-mode annoyingly overwrites the  global keybinding C-c C-c with
;; some of its internal crab. So, force  it to use my own defun. Also,
;; while  we're  at it,  disable  electric  indent, it's  annoying  in
;; configs. Applies for derivates as well.

(defun tvd-disarm-conf-mode()
  (local-set-key  (kbd "C-c C-c") 'comment-or-uncomment-region-or-line)
  (electric-indent-local-mode 0))

(add-something-to-mode-hooks '(conf cisco fundamental conf-space pod) 'tvd-disarm-conf-mode)
;; --------------------------------------------------------------------------------

;; *** Config::General mode
;; **** Config and doc
;; [[https://github.com/TLINDEN/config-general-mode][config-general-mode]] (also on Melpa).

;; My own mode for [[http://search.cpan.org/dist/Config-General/][Config::General]]
;; config files. Whenever I write some perl stuff, which needs a config file, I use
;; this module (and I do this a lot). Previously I used conf-mode or html-mode, but
;; both did not satisfy me. Now (as of 20170625) I solved this mess once and for all.

(require 'config-general-mode)
(require 'sh-script)

;; **** Convenicence Wrappers
(defun config-general-completion-at-point ()
  "Complete word at point using hippie-expand, if not on a comment."
  (interactive)
  (when (looking-back "[-%$_a-zA-Z0-9]")
    (unless (eq (get-text-property (point) 'face) 'font-lock-comment-face)
      (hippie-expand nil))))

(defun config-general-do-electric-tab ()
  "Enter a <TAB> or goto current indentation."
  (interactive)
  (if (eq (point) (line-end-position))
        (indent-for-tab-command)
      (back-to-indentation)))

(defun config-general-tab-or-expand ()
  "Do electric TAB or completion depending where point is.

This is just a convenience function, which can be mapped
to `tab' by the user. .Not in use by default."
  (interactive)
  (unless (config-general-completion-at-point)
    (config-general-do-electric-tab)))

;; FIXME: Use this  patched version for older emacsen  and the default
;; for version which contain the patch (if any, ever).
;;
;; The original  function try-expand-dabbrev-all-buffers  doesn't work
;; correctly, it ignores a buffer-local configuration of the variables
;; hippie-expand-only-buffers  and hippie-expand-ignore-buffers.  This
;; is the patched version of the function.
;;
;; Bugreport: http://debbugs.gnu.org/cgi/bugreport.cgi?bug=27501
(defun config-general--try-expand-dabbrev-all-buffers (old)
    "Try to expand word \"dynamically\", searching all other buffers.
The argument OLD has to be nil the first call of this function, and t
for subsequent calls (for further possible expansions of the same
string).  It returns t if a new expansion is found, nil otherwise."
  (let ((expansion ())
        (buf (current-buffer))
        (orig-case-fold-search case-fold-search)
        (heib hippie-expand-ignore-buffers)
        (heob hippie-expand-only-buffers)
        )
    (if (not old)
        (progn
          (he-init-string (he-dabbrev-beg) (point))
          (setq he-search-bufs (buffer-list))
          (setq he-searched-n-bufs 0)
          (set-marker he-search-loc 1 (car he-search-bufs))))

    (if (not (equal he-search-string ""))
        (while (and he-search-bufs
                    (not expansion)
                    (or (not hippie-expand-max-buffers)
                        (< he-searched-n-bufs hippie-expand-max-buffers)))
          (set-buffer (car he-search-bufs))
          (if (and (not (eq (current-buffer) buf))
                   (if heob
                       (he-buffer-member heob)
                     (not (he-buffer-member heib))))
              (save-excursion
                (save-restriction
                  (if hippie-expand-no-restriction
                      (widen))
                  (goto-char he-search-loc)
                  (setq expansion
                        (let ((case-fold-search orig-case-fold-search))
                          (he-dabbrev-search he-search-string nil)))
                  (set-marker he-search-loc (point))
                  (if (not expansion)
                      (progn
                        (setq he-search-bufs (cdr he-search-bufs))
                        (setq he-searched-n-bufs (1+ he-searched-n-bufs))
                        (set-marker he-search-loc 1 (car he-search-bufs))))))
            (setq he-search-bufs (cdr he-search-bufs))
            (set-marker he-search-loc 1 (car he-search-bufs)))))

    (set-buffer buf)
    (if (not expansion)
        (progn
          (if old (he-reset-string))
          ())
      (progn
        (he-substitute-string expansion t)
        t))))

;; **** Mode Hook

;; I  use TAB  for completion  AND tab  and outshine.  Also, the  mode
;; enables  electric  indent  automatically,  but I  disabled  it  for
;; conf-mode (see tvd-disarm-conf-mode), therefore I re-enable it here
;; for config-general-mode (which inherits from conf-mode).
(add-hook 'config-general-mode-hook
          (lambda ()
            (electric-indent-mode)
            ;; de-activate some senseless bindings
            (local-unset-key (kbd "C-c C-c"))
            (local-unset-key (kbd "C-c C-p"))
            (local-unset-key (kbd "C-c C-u"))
            (local-unset-key (kbd "C-c C-w"))
            (local-unset-key (kbd "C-c C-x"))
            (local-unset-key (kbd "C-c :"))
            (local-set-key (kbd "<tab>") 'config-general-tab-or-expand)

            ;; from shell-script-mode, turn << into here-doc
            (sh-electric-here-document-mode 1)

            ;; Inserting a brace or quote automatically inserts the matching pair
            (electric-pair-mode t)
            (setq-local hippie-expand-only-buffers '(config-general-mode))

            ;; configure order of expansion functions
            (if (version< emacs-version "25.1")
                (set (make-local-variable 'hippie-expand-try-functions-list)
                     '(try-expand-dabbrev ;; use patched version
                       config-general--try-expand-dabbrev-all-buffers
                       try-complete-file-name-partially
                       try-complete-file-name))
              (set (make-local-variable 'hippie-expand-try-functions-list)
                   '(try-expand-dabbrev
                     try-expand-dabbrev-all-buffers
                     try-complete-file-name-partially
                     try-complete-file-name)))
            ;; enable
            (add-hook 'completion-at-point-functions 'config-general-completion-at-point)
            )
          )

;; --------------------------------------------------------------------------------
;; *** Xmodmap Mode

;; the shortest mode ever, [[https://www.emacswiki.org/emacs/XModMapMode][via emacswiki]].

(define-generic-mode 'xmodmap-mode
  '(?!)
  '("add" "clear" "keycode" "keysym" "pointer" "remove")
  '(("[0-9]+" . 'font-lock-variable-name-face))
  '("[xX]modmap\\(rc\\)?\\'")
  nil
  "Simple mode for xmodmap files.")

;; [[https://www.emacswiki.org/emacs/GenericMode][see GenericMode for more examples]].

;; *** MMM Mode
;; **** MMM configure:
(add-to-list 'load-path (concat tvd-lisp-dir "/mmm-mode"))

(require 'cl)
(require 'mmm-auto)
(require 'mmm-vars)

(setq mmm-submode-decoration-level 2)


;; [[https://github.com/purcell/mmm-mode][mmm-mode github]]
;; see doc for class definition in var 'mmm-classes-alist

;; **** MMM config for POD mode
(mmm-add-classes
 '((html-pod
    :submode html-mode ;; web-mode doesnt work this way!
    :delimiter-mode nil
    :front "=begin html"
    :back "=end html")))

(mmm-add-mode-ext-class 'pod-mode nil 'html-pod)

(add-hook 'pod-mode-hook 'mmm-mode-on)

;; ** Text Manupilation
;; *** expand-region

;; One of the  best modes I ever discovered. Press  C-= multiple times
;; to create a larger and larger region. I use C-0 (zero) because on a
;; german keyboard this is the same as C-= without pressing shift.

(require 'expand-region)
(global-set-key (kbd "C-0")             'er/expand-region)                                ; C-= without pressing shift on DE keyboard

;; related to ER:
;; *** Mark, Copy, Yank Things

;; For a long time this stuff was  located here in my emacs config. As
;; it grew larger  and larger I decided  to put it into  its own mode:
;; mark-copy-yank-things-mode,  which can  be  found  on github  these
;; days.

;; With this,  you can quickly mark  or copy or copy+yank  things like
;; words, ip's,  url's, lines or defun's  with one key binding.  I use
;; this permanently and couldn't live without it anymore.

;; A special feature is the copy+yanking, this is something vi offers:
;; go to a line, press yy, then  p and the current line will be yanked
;; below.  Prefix  with a  number and copy+yank  more lines.   This is
;; really cool and (in  vi) often used. So, with this  mode, I can use
;; it with  emacs as well. For  example, say you edit  a configuration
;; file  and added  a  complicated  statement. Next  you  need to  add
;; another very similar  statement. Instead of entering  it again, you
;; just  hit  <C-c  y y>  and  the  current  line  appears as  a  copy
;; below. Change the differences and you're done!

(require 'mark-copy-yank-things-mode)
(mark-copy-yank-things-global-mode)

;; The mode  has a rather  impractical prefix since it's  published on
;; github and therefore must be written  in a way not to disturb other
;; modes. However, I myself need those simple prefixes:
(define-key mark-copy-yank-things-mode-map (kbd "C-c")   'mcyt-copy-map)
(define-key mark-copy-yank-things-mode-map (kbd "M-a")   'mcyt-mark-map)
;; I use the default yank map

;; With this I  put the last thing  copied into a register  'c.  I can
;; then  later  yank  this  using C-v  anytime  without  browsing  the
;; kill-ring if I kill things between yanking.  So, C-v always inserts
;; the last copied thing, while C-y yanks the last thing killed, which
;; might be something else.
(advice-add 'mcyt--copy-thing
            :after
            '(lambda (&rest args)
               (with-temp-buffer
                 (yank)
                 (copy-to-register 'c (point-min) (point-max)))))

(defun tvd-insert-c-register ()
  (interactive)
  (insert-register 'c))

(global-set-key (kbd "C-v")             'tvd-insert-c-register)

;; copy  a real  number  and  convert it  to  german punctuation  upon
;; yanking, so  I can  do some calculations  in 'calculator,  copy the
;; result NNN.NN and  paste it into my online  banking formular, where
;; it appears as NNN,NN.
(defun tvd-mcyt-copy-euro (&optional arg)
  "Copy  euro  at point  into  kill-ring  and convert  to  german
punctuation"
  (interactive "P")
  (mcyt--blink-and-copy-thing 'mcyt-beginning-of-ip 'mcyt-end-of-ip arg)
  (with-temp-buffer
    (yank)
    (beginning-of-buffer)
    (while (re-search-forward "\\." nil t)
      (replace-match ","))
    (kill-region (point-min) (point-max))))

(eval-after-load "mark-copy-yank-things-mode"
  '(progn
     (add-hook 'mark-copy-yank-things-mode-hook
               (lambda () ;; g like [G]eld
                 (define-key mcyt-copy-map (kbd "g") 'tvd-mcyt-copy-euro)))))



;; --------------------------------------------------------------------------------

;; *** change-inner

;; I use change-inner with a prefix key and some wrappers around
;; mark-copy-yank-things-mode, which is related to change-inner
;; and expand-region.

;; [[https://github.com/magnars/change-inner.el][github source]]:
(require 'change-inner)

;; first some functions:

(defun tvd-ci (beg end &optional ins)
  "change-inner simulator which works with symbols instead of strings.

BEG and END must be executable elisp symbols moving (point). Everything
in between will be killed. If INS is non-nil, it will be inserted then."
  (interactive)
  (let ((B nil))
    (funcall beg)
    (setq B (point))
    (funcall end)
    (kill-region B (point))
    (when ins
      (insert ins))))

(defun tvd-ci-comment ()
  "\"change inner\" a whole comment [block]."
  (interactive)
  (tvd-ci 'mcyt-beginning-of-comment-block
          'mcyt-end-of-comment-block
          (format "%s;# " comment-start)))

(defun tvd-ci-quote ()
  "\"change inner\" quoted text."
  (interactive)
  (tvd-ci 'mcyt-beginning-of-quote
          'mcyt-end-of-quote))

(defun tvd-ci-word ()
  "\"change inner\" a word (like cw in vi)."
  (interactive)
  (tvd-ci 'mcyt-beginning-of-symbol
          'mcyt-end-of-symbol))

(defun tvd-ci-line ()
  "\"change inner\" a whole line."
  (interactive)
  (tvd-ci 'beginning-of-line
          'end-of-line))

(defun tvd-ci-paragraph ()
  "\"change inner\" a whole paragraph."
  (interactive)
  (tvd-ci 'backward-paragraph
          'forward-paragraph))

(defun tvd-ci-buffer ()
  "\"change inner\" a whole buffer."
  (interactive)
  (tvd-ci 'point-min
          'point-max))

(defun tvd-ci-sexp ()
  "\"change inner\" a whole sexp."
  (interactive)
  (er/mark-inside-pairs)
  (call-interactively 'kill-region))

;; Define ALT_R (AltGR) + i as my prefix command for change-inner stuff.
;; Since I use a german keyboard, this translates to →.
;; I'll refrence it here now as <A-i ...>
(define-prefix-command 'ci-map)
(global-set-key (kbd "→") 'ci-map)

;; typing the prefix key twice calls the real change-inner
(define-key ci-map (kbd "→") 'change-inner) ;; <A-i A-i>

(define-key ci-map (kbd "c") 'tvd-ci-comment) ;; <A-i c>
(define-key ci-map (kbd "¢") 'tvd-ci-comment) ;; <A-i A-c>

(define-key ci-map (kbd "q") 'tvd-ci-quote) ;; <A-i q>
(define-key ci-map (kbd "@") 'tvd-ci-quote) ;; <A-i A-q>

(define-key ci-map (kbd "w") 'tvd-ci-word) ;; <A-i w>
(define-key ci-map (kbd "ł") 'tvd-ci-word) ;; <A-i A-w>

(define-key ci-map (kbd "l") 'tvd-ci-line) ;; <A-i l>

(define-key ci-map (kbd "s") 'tvd-ci-sexp) ;; <A-i s>
(define-key ci-map (kbd "ſ") 'tvd-ci-sexp) ;; <A-i A-s>

(define-key ci-map (kbd "p") 'tvd-ci-paragraph) ;; <A-i p>
(define-key ci-map (kbd "þ") 'tvd-ci-paragraph) ;; <A-i A-p>

(define-key ci-map (kbd "a") 'tvd-ci-buffer) ;; <A-i a>
(define-key ci-map (kbd "æ") 'tvd-ci-buffer) ;; <A-i A-a>

;; --------------------------------------------------------------------------------
;; *** Rotate text

;; This one is great as well, I  use it to toggle flags and such stuff
;; in configs or code with just one key binding.

;; Source: [[http://nschum.de/src/emacs/rotate-text/][nschum.de]]

(autoload 'rotate-text "rotate-text" nil t)
(autoload 'rotate-text-backward "rotate-text" nil t)

;; my toggle list
(setq rotate-text-words '(("width" "height")
                          ("left" "right" "top" "bottom")
                          ("ja" "nein")
                          ("off" "on")
                          ("true" "false")
                          ("nil" "t")
                          ("yes" "no")))

;; C-t normally used by transpose-chars, so, unbind it first
(global-unset-key (kbd "C-t"))

;; however, we cannot  re-bind it globally since then it  could not be
;; used in org-mode for org-todo (see below) FIXME: I only use the "t"
;; short command anymore, so C-t would be free now, wouldn't it?
(add-something-to-mode-hooks
 '(c c++ cperl vala web emacs-lisp python ruby)
 '(lambda ()
    (local-set-key (kbd "C-t") 'rotate-text)))

;; --------------------------------------------------------------------------------

;; *** Word wrapping
;; same as word-wrap but without the fringe which I hate the most!
(add-something-to-mode-hooks '(tex text eww) 'visual-line-mode)

;; however, it's required when coding, so enable it globally
;; overwritten by visual-line-mode above for specifics
(setq word-wrap t)
;; --------------------------------------------------------------------------------

;; *** Viking Mode

;; Delete  stuff fast.  Press the  key  multiple times  - delete  more
;; things. Inspired by expand-region. Written by myself.

(require 'viking-mode)
(viking-global-mode)
(setq viking-greedy-kill nil)
(define-key viking-mode-map (kbd "M-d") 'viking-repeat-last-kill)
;; --------------------------------------------------------------------------------

;; *** HTMLize

;; extracted  from  debian package  emacs-goodies-el-35.2+nmu1,  since
;; there's no other source left. Generates a fontified html version of
;; the current buffer, however it looks.

(require 'htmlize)
(setq htmlize-output-type "inline-css")


;; *** iEdit (inline edit multiple searches)

;; Edit all occurences of something at once. Great for re-factoring.

(require 'iedit)

(global-set-key (kbd "C-c C-e")           'iedit-mode)

;; Keep buffer-undo-list as is while iedit is active, that is, as long
;; as I am  inside iedit I can undo/redo  current occurences. However,
;; if I leave iedit and issue  the undo command, ALL changes made with
;; iedit  are undone,  whereas the  default behaviour  would be  to go
;; through every change made iside iedit, which I hate.

;; iedit doesn't  provide a customizable  flag to configure  it's undo
;; behavior, so, I modify it myself using defadvice.

(setq tvd-buffer-undo-list nil)
(advice-add 'iedit-mode :before '(lambda (&rest args) ;; save current
                                   (setq tvd-buffer-undo-list buffer-undo-list)))

(advice-add 'iedit-mode :after '(lambda (&rest args)  ;; restore previously saved
                                  (setq buffer-undo-list tvd-buffer-undo-list)))

;; --------------------------------------------------------------------------------

;; ** Interactives
;; *** Hydra
;; Used here and there below
(require 'hydra)
;; *** eShell stuff, or if interactive stuff is needed, use ansi-term

;; I am  a hardcore bash  user, but from time  to time eshell  is good
;; enough. It's great when used remote when only sftp is supported.

(require 'eshell)

;; fac'ifier
(defmacro with-face (str &rest properties)
  `(propertize ,str 'face (list ,@properties)))

;; custom prompt, which resembles my bash prompt
(defun shk-eshell-prompt ()
  (let ((header-bg "Azure"))
    (concat
     (with-face "\n")
     (with-face (format-time-string
                 "[%Y-%m-%d %H:%M] --- ["
                 (current-time)) :background header-bg :foreground "Black")
     (with-face (concat (eshell/pwd) "") :background header-bg :foreground "Blue")
     (with-face "] --- " :background header-bg :foreground "Black")
     (with-face  (or
                  (ignore-errors (format "(%s)" (vc-responsible-backend default-directory)))
                  "") :background header-bg)
     (with-face "\n" :background header-bg)
     (with-face user-login-name :foreground "blue")
     "@"
     (with-face "localhost" :foreground "blue")
     (if (= (user-uid) 0)
         (with-face " #" :foreground "red")
       " $")
     " ")))

(setq eshell-prompt-function 'shk-eshell-prompt)
(setq eshell-highlight-prompt nil)

;; I use my own virtual loggin target /dev/log, just redirect
;; command output to /dev/log and it will be saved to
;; the *LOG* buffer. > inserts, >> appends
;; N.B: /dev/kill puts the stuff into the kill-ring.
(defun log-comment ()
  (with-current-buffer (get-buffer-create "*LOG*")
    (insert (format "# %s\n" (time-stamp-string)))))

(defun log-insert (string)
  (with-current-buffer (get-buffer-create "*LOG*")
    (delete-region (point-min) (point-max))
    (log-comment)
    (insert string)
    (message "wrote output to *LOG* buffer")))

(defun log-append (string)
  (with-current-buffer (get-buffer-create "*LOG*")
    (end-of-buffer)
    (newline)
    (log-comment)
    (insert string)
    (message "wrote output to *LOG* buffer")))

;; must return a defun which gets the stuff as ARG1
;; 'mode is 'overwrite or 'append
(add-to-list 'eshell-virtual-targets '("/dev/log" (lambda (mode)
                                              (if (eq mode 'overwrite)
                                                  'log-insert
                                                'log-append))
                                      t
                                      ))

;; eshell config
(eval-after-load "eshell"
  '(progn
     (add-hook 'eshell-mode-hook
               (lambda ()
                 (local-unset-key (kbd "C-c C-r")) ; we're already using this for windresize
                 (add-to-list 'eshell-visual-commands "tail")
                 (add-to-list 'eshell-visual-commands "top")
                 (add-to-list 'eshell-visual-commands "vi")
                 (add-to-list 'eshell-visual-commands "ssh")
                 (add-to-list 'eshell-visual-commands "tail")
                 (add-to-list 'eshell-visual-commands "mutt")
                 (add-to-list 'eshell-visual-commands "note")
                 (setenv "TERM" "xterm")
                 (local-set-key (kbd "C-l") 'eshell/clear)
                 (define-key viking-mode-map (kbd "C-d") nil) ;; need to undef C-d first
                 (local-set-key (kbd "C-d") 'eshell/x)
                 (setq mode-name "ESH"
                       eshell-hist-ignoredups t
                       eshell-history-size 5000
                       eshell-where-to-jump 'begin
                       eshell-review-quick-commands nil
                       eshell-smart-space-goes-to-end t
                       eshell-scroll-to-bottom-on-input 'all
                       eshell-error-if-no-glob t
                       eshell-save-history-on-exit t
                       eshell-prefer-lisp-functions t)))))

;; exit and restore viking key binding afterwards
(defun eshell/x (&rest args)
  (interactive)
  (eshell-life-is-too-much)
  (define-key viking-mode-map (kbd "C-d") 'viking-kill-thing-at-point))

;; open files in emacs, split the shell if not already splitted
;; open empty window if no file argument given.
(defun eshell/emacs (&rest args)
  "Editor commands fired from eshell will be handled by emacs, which already runs anyway."
  (interactive)
  (let* ((framesize (frame-width))
         (winsize (window-body-width)))
    (progn
      (if (eq winsize framesize)
          (split-window-horizontally))
      (other-window 1)
      (if (null args)
          (bury-buffer)
        (mapc #'find-file (mapcar #'expand-file-name (eshell-flatten-list (reverse args))))))))

(defun eshell/clear ()
  "Better clear  command than (recenter  0) which doesn't work  as I
want.  This version really removes  the output of previous commands
and puts the shell to the beginning of a really (then) empty eshell
buffer. However,  just to be sure  that I do no  accidentally clear
some  shell output  that might  be useful  in the  future, it  also
copies   the   cleared   stuff   into   a   backup   buffer   named
*eshell-log-buffer*, just in case."
  (interactive)
  (let ((beg (point-min))
        (end (point-max))
        (savebuffer "*eshell-log-buffer*")
        (log (buffer-substring-no-properties (point-min) (point-max))))
    (progn
      (if (not (get-buffer savebuffer))
          (get-buffer-create savebuffer))
      (with-current-buffer savebuffer
        (goto-char (point-max))
        (insert log))
      (delete-region beg end)
      (eshell-emit-prompt))))

(defun eshell/perldoc (&rest args)
  "Like `eshell/man', but invoke `perldoc'."
  (funcall 'eshell/perldoc (apply 'eshell-flatten-and-stringify args)))

(defun eshell/perldoc (man-args)
  (interactive "sPerldoc: ")
  (require 'man)
  (let ((manual-program "perldoc"))
    (man man-args)))

(defun eshell-here ()
  "Opens up a new shell in the directory associated with the
current buffer's file. The eshell is renamed to match that
directory to make multiple eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (height (/ (window-total-height) 3))
         (name   (car (last (split-string parent "/" t)))))
    (split-window-vertically (- height))
    (other-window 1)
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))
    (insert (concat "ls"))
    (eshell-send-input)))

;; via howardism
(defun eshell-there (host)
  "Opens a shell on a remote host using tramp."
  (interactive "sHost: ")
  (let ((default-directory (format "/%s:" host)))
    (eshell host)))

(defalias 'es        'eshell-here)
(defalias 'et        'eshell-there)
(defalias 'eshell/vi 'eshell/emacs)

;; plan9 smart command, edit while exec if not silent or successful
(require 'em-smart)

;; eshell shell aliases. I set the global
;; defvar here so there's no need to transport
;; ~/.emacs.d/eshell/aliases across networks
(setq eshell-command-aliases-list ())

(defun +alias (al cmd)
  "handy wrapper function to convert alias symbols
to alias strings to avoid writing 4 quotes per alias.
AL is a single-word symbol naming the alias, CMD is
a list symbol describing the command."
  (add-to-list 'eshell-command-aliases-list
               (list (symbol-name al)
                     (mapconcat 'symbol-name cmd " "))))

;; actual aliases
(+alias 'l      '(ls -laF $*))
(+alias 'll     '(ls -l $*))
(+alias 'la     '(ls -a $*))
(+alias 'lt     '(ls -ltr $*))
(+alias '..     '(cd ..))
(+alias '...    '(cd ../..))
(+alias '....   '(cd ../../..))
(+alias '.....  '(cd ../../../..))
(+alias 'md     '(mkdir -p $*))
(+alias 'emacs  '(find-file $1))
(+alias 'less   '(find-file-read-only $1))
(+alias 'x      '(eshell/exit))

;; no need for less or more, this is emacs, isn't it?
(setenv "PAGER" "cat")

;; --------------------------------------------------------------------------------

;; *** Emacs LISP interactive

;; General configuration for all things elisp.

;; By using C-x-e I can push region or buffer
;; of lisp code (i.e. inside *scratch*) into
;; REPL where it will be evaluated

(defun tvd-get-code()
  "helper: returns marked region or the whole buffer contents"
  ;; FIXME: mv to string helpers?
  (if mark-active
      (let (  ;; save region and buffer
            (partb (buffer-substring-no-properties (region-beginning) (region-end)))
            (whole (buffer-substring-no-properties (point-min) (point-max)))
            )
        (if (> (length partb) 0)
            partb
          whole
          )
        )
    ;; no mark, also return everything
    (buffer-substring-no-properties (point-min) (point-max))))

(defun tvd-send-region-to-repl ()
  "put region or buffer into elisp repl and eval"
  (interactive)
  (let ( ;; fetch region or buffer contents
        (code  (tvd-get-code)))
    (progn
      (if (not (get-buffer "*ielm*"))
          ;; ielm not yet running, start it in split window but stay here
          (progn
            (split-window-horizontally)
            (other-window 1)
            (ielm)
            (other-window 1)))
      ;; finially, paste content into ielm and evaluate it
      ;; still we stay where we are
      (with-current-buffer "*ielm*"
        (goto-char (point-max))
        (insert code)
        (ielm-return)))))

(defun tvd-elisp-eval()
  "just eval region or buffer whatever feasible"
  (interactive)
  (progn
    (if mark-active
        (eval-region)
      (eval-buffer))))

(defun ff ()
  "Jump to function definition at point."
  (interactive)
  (find-function-other-window (symbol-at-point)))

(defun tvd-make-defun-links ()
  "experimental: make function calls clickable, on click, jump to definition of it"
  (interactive)
  (let ((beg 0)
        (end 0)
        (fun nil))
    (goto-char (point-min))
    (while (re-search-forward "(tvd[-a-z0-9]*" nil t)
      (setq end (point))
      (re-search-backward "(" nil t)
      (forward-char 1)
      (setq beg (point))
      (setq fun (buffer-substring-no-properties beg end))
      (make-button beg end 'action
                   (lambda (x)
                     (find-function-other-window (symbol-at-point))))
      (goto-char end))))

(defun emacs-change-log (entry)
  "Add a changelog entry to .emacs Changelog"
  (interactive "Menter change log entry: ")
  (save-excursion
    (show-all)
    (beginning-of-buffer)
    (re-search-forward ";; .. Changelog")
    (next-line)
    (tvd-outshine-end-of-section)
    (insert (format ";;    - %s\n" entry))))

;; elisp config
(add-hook 'emacs-lisp-mode-hook
          (lambda()
            ;; non-separated x-e == eval hidden, aka current buffer
            (local-set-key (kbd "C-x C-e")  'tvd-elisp-eval)
            ;; separate 'e' == separate buffer
            (local-set-key (kbd "C-x e")    'tvd-send-region-to-repl)
            (setq mode-name "EL"
                  show-trailing-whitespace t)
            (eldoc-mode t)

            ;; enable outline (with outshine)
            (outline-minor-mode)

            ;; enable outshine mode
            (outshine-hook-function)

            (electric-indent-mode t)))

;; use UP arrow for history in *ielm* as well, just as C-up
(add-hook 'comint-mode-hook
          (lambda()
            (define-key comint-mode-map [up] 'comint-previous-input)))

;; sometimes I use lisp in minibuffer
(defalias 'ee        'eval-expression)

;; sometimes I eval regions
(defalias 'er        'eval-region)

;; ... or defuns
(defalias 'ef        'eval-defun)

;; I like to have some functions fontified differently
(font-lock-add-keywords
 'emacs-lisp-mode
 '(("(\\s-*\\(eq\\|if\\|cond\\|and\\|set\\|or\\|not\\|when\\|setq\\|let**\\|lambda\\|kbd\\|defun\\|car\\|cdr\\)\\s-+"
    1 'font-lock-keyword-face)))

;; same applies for quoted symbols
(font-lock-add-keywords
 'emacs-lisp-mode
 '(("'[-a-zA-Z_][-a-zA-Z0-9_]*\\>" 0 'font-lock-constant-face)))

;; I  hate it  when help,  debug,  ielm and  other peripheral  buffers
;; litter  my emacs  window setup.  So, this  function fixes  this: it
;; opens a new frame with all those buffers already opened and pinned.

(defun dev ()
  "Open a new emacs frame with some development peripheral buffers."
  (interactive)
  (let ((F (new-frame)))
    (with-selected-frame F
      (with-current-buffer (get-buffer-create "*Help*")
        (help-mode))
      (with-current-buffer (get-buffer-create "*ielm*")
        (ielm))
      (with-current-buffer (get-buffer-create "*suggest*")
        (suggest))
      (switch-to-buffer "*ielm*")
      (split-window-horizontally)
      (split-window-vertically)
      (windmove-down)
      (switch-to-buffer "*suggest*")
      (tvd-suggest-reload)
      (tvd-suggest-reload)
      (windmove-right)
      (switch-to-buffer "*Help*")
      (split-window-vertically)
      (windmove-down)
      (switch-to-buffer "*scratch*")
      (set-window-dedicated-p (selected-window) t)
      (set-background-color "azure"))))


;; --------------------------------------------------------------------------------
;; *** el2markdown

;; [[https://github.com/Lindydancer/el2markdown][el2markdown]] is a module which
;; can be used to convert Commentary sections into markdown files. I use this to
;; avoid maintaining the README.md and the Commentary section in parallel.

(require 'el2markdown)

;; To  use,   call  el2markdown-view-buffer   and  put  it   into  the
;; README.md. Take care though: it doesn't convert the META section.

;; FIXME: write a wrapper to circumvent these restrictions.

;; *** tramp mode

;; Edit remote files, one of the best things in emacs. I use it every day heavily.

;; Sample: C-x-f /$host:/$file ($host as of .ssh/config or direct, $file including completion)

;; doku: [[http://www.gnu.org/software/tramp/][gnu.org]]
(setq tramp-default-method "ssh"
      tramp-default-user nil
      ido-enable-tramp-completion t)

;; see also backup section

;; --------------------------------------------------------------------------------

;; *** org mode

;; I use org mode to take notes  mostly at work. I also track projects
;; and  TODO  lists  etc.   I  do not,  however,  use  agenda  or  any
;; scheduling whatsoever.

(require 'org)

;; I like custom bullets
(require 'org-bullets)

;; enable syntax highlighting for embedded source blocks
(require 'ob-python)
(require 'ob-perl)
(require 'ob-shell)

(setq org-bullets-bullet-list '("►" "✜" "✸" "✿" "♦"))

;; capture target, os-dependend
(if (null tvd-win-home)
    (setq tvd-org-file (concat tvd-lisp-dir "/notizen.org")
          org-attach-directory (concat tvd-lisp-dir "/attachments"))
  (setq tvd-org-file (concat tvd-win-home "/notizen.org")
        org-attach-directory (concat tvd-win-home "/attachments")))

;; text formatting made easy, bound to C-c keys locally
(defun tvd-org-emphasize(CHAR)
  "expand once if no region and apply emphasize CHAR"
  (interactive)
  (unless (region-active-p)
    (er/expand-region 1))
  (org-emphasize CHAR))

(defun bold()
  "bold text in org mode"
  (interactive)
  (tvd-org-emphasize '42))

(defun italic()
  "italic text in org mode"
  (interactive)
  (tvd-org-emphasize '47))

(defun code()
  "verbatim text in org mode"
  (interactive)
  (tvd-org-emphasize '126))

(defun underline()
  "underline text in org mode"
  (interactive)
  (tvd-org-emphasize '95))

;; my org-mode specific <C-left> and <C-right>
(defun tvd-org-left-or-level-up()
  "jump one word to the left if not on a org heading,
otherwise fold current level and jump one level up."
  (interactive)
  (if (and (org-at-heading-p) (looking-at "*"))
      (progn
        (hide-subtree)
        (outline-up-heading 1))
    (left-word)))

(defun tvd-org-heading-up()
  "If on a heading, fold current heading, jump one level
up and unfold it, otherwise jump paragraph as usual."
  (interactive)
  (if (and (org-at-heading-p) (looking-at "*"))
      (progn
        (hide-subtree)
        (org-backward-heading-same-level 1)
        (org-cycle))
    (backward-paragraph)))

(defun tvd-org-heading-down()
  "If on a heading, fold current heading, jump one level
down and unfold it, otherwise jump paragraph as usual."
  (interactive)
  (if (and (org-at-heading-p) (looking-at "*"))
      (progn
        (hide-subtree)
        (org-forward-heading-same-level 1)
        (org-cycle))
    (forward-paragraph)))

;; org-mode specific config, after load
(eval-after-load "org"
  '(progn
     (add-hook 'org-mode-hook
               (lambda ()
                 (setq
                  org-M-RET-may-split-line nil
                  org-agenda-files (list tvd-org-file)
                  org-agenda-restore-windows-after-quit t
                  org-blank-before-new-entry (quote ((heading . auto) (plain-list-item . auto)))
                  org-catch-invisible-edits (quote error)
                  org-columns-default-format "%80ITEM %22Timestamp %TODO %TAGS %0PRIORITY"
                  org-insert-heading-always-after-current (quote t)
                  org-mouse-1-follows-link nil
                  org-remember-store-without-prompt t
                  org-reverse-note-order t
                  org-startup-indented t
                  org-startup-truncated nil
                  org-return-follows-link t
                  org-use-speed-commands t
                  org-yank-adjusted-subtrees t
                  org-refile-targets '((nil . (:maxlevel . 5)))
                  org-refile-use-outline-path t
                  org-outline-path-complete-in-steps nil
                  org-completion-use-ido t
                  org-support-shift-select t
                  org-hide-emphasis-markers t
                  org-fontify-done-headline t
                  org-pretty-entities t
                  org-use-sub-superscripts nil
                  org-confirm-babel-evaluate nil)
                                        ; shortcuts
                 (setq org-speed-commands-user
                       (quote (
                               ("0" . ignore)
                               ("1" . delete-other-windows)
                               ("2" . ignore)
                               ("3" . ignore)
                               ("d" . org-archive-subtree-default-with-confirmation) ; delete, keep track
                               ("v" . org-narrow-to-subtree) ; only show current heading ("view")
                               ("q" . widen)                 ; close current heading and show all ("quit")
                               (":" . org-set-tags-command)  ; add/edit tags
                               ("t" . org-todo)              ; toggle todo type, same as C-t
                               ("z" . org-refile)            ; archive the (sub-)tree
                               ("a" . org-attach)            ; manage attachments
                               )))
                                        ; same as toggle
                 (local-set-key (kbd "C-t") 'org-todo)

                                        ; alt-enter = insert new subheading below current
                 (local-set-key (kbd "<M-return>") 'org-insert-subheading)

                                        ; search for tags (ends up in agenda view)
                 (local-set-key (kbd "C-f") 'org-tags-view)

                                        ; run presenter, org-present must be installed and loadedwhite
                 (local-set-key (kbd "C-p") 'org-present)

                                        ; todo colors
                 (setq org-todo-keyword-faces '(
                                                ("TODO"   . (:foreground "#b70101"     :weight bold))
                                                ("START"  . (:foreground "blue"        :weight bold))
                                                ("WAIT"   . (:foreground "darkorange"  :weight bold))
                                                ("DONE"   . (:foreground "forestgreen" :weight bold))
                                                ("CANCEL" . (:foreground "red"         :weight bold))
                                                ))

                 (local-set-key (kbd "C-c b") 'bold)
                 (local-set-key (kbd "C-c /") 'italic)
                 (local-set-key (kbd "C-c 0") 'code) ; aka = without shift
                 (local-set-key (kbd "C-c _") 'underline)

                                        ; edit babel src block in extra buffer:
                                        ; default is C-c ' which is hard to type
                                        ; brings me to src code editor buffer
                                        ; Also note: enter <s then TAB inserts a code block
                                        ; Next, C-c C-c executes the code, adding :results table at the
                                        ; end of the begin line, creates a table of the output
                 (local-set-key (kbd "C-c C-#") 'org-edit-special)

                                        ; faster jumping
                 (local-set-key (kbd "<C-up>")   'tvd-org-heading-up)
                 (local-set-key (kbd "<C-down>") 'tvd-org-heading-down)

                                        ; move word left or heading up, depending where point is
                 (local-set-key (kbd "<C-left>") 'tvd-org-left-or-level-up)

                                        ; use nicer bullets
                 (org-bullets-mode 1))

               (org-babel-do-load-languages
                'org-babel-load-languages
                '((python     . t)
                  (emacs-lisp . t)
                  (shell      . t)
                  (perl       . t)
                  ))
                 )))

;; no more ... at the end of a heading
(setq org-ellipsis " ⤵")

;; my own keywords, must be set globally, not catched correctly inside hook
(setq org-todo-keywords
      '((sequence "TODO" "START" "WAIT" "|" "DONE" "CANCEL")))

;; I always want to be able to capture, even if no ORG is running
(global-set-key (kbd "C-n")             (lambda () (interactive) (org-capture)))

;; must be global since code edit sub buffers run their own major mode, not org
(global-set-key (kbd "C-c C-#")         'org-edit-src-exit)

;; some org mode vars must be set globally
(setq org-default-notes-file tvd-org-file
      org-startup-indented t
      org-indent-indentation-per-level 4)

;; my own capture templates
(setq org-capture-templates
      '(("n" "Project" entry (file+headline tvd-org-file "Unsorted Tasks")
         "* TODO %^{title}\n%u\n** Kostenstelle\n** Contact Peer\n** Contact Customer\n** Aufträge\n** Daten\n** Notizen\n  %i%?\n"
         :prepend t :jump-to-captured t)

        ("j" "Journal" entry (file+headline tvd-org-file "Kurznotizen")
         "* TODO %^{title}\n%u\n  %i%?\n" :prepend t :jump-to-captured t)

        ("c" "Copy/Paste" entry (file+headline tvd-org-file "Kurznotizen")
         "* TODO %^{title}\n%u\n  %x\n" :immediate-finish t :prepend t :jump-to-captured t)))

;; follow links using eww, if present
(if (fboundp 'eww-browse-url)
    (setq browse-url-browser-function 'eww-browse-url))

;; mark narrowing with an orange fringe, the advice for 'widen
;; is in the outline section.
(advice-add 'org-narrow-to-subtree :after
            '(lambda (&rest args)
               (set-face-attribute 'fringe nil :background tvd-fringe-narrow-bg)))

;; always use the latest docs
(with-eval-after-load 'info
    (info-initialize)
    (add-to-list 'Info-directory-list
                 (expand-file-name "~/.emacs.d/lisp/org/doc")))

;; --------------------------------------------------------------------------------
;; *** org table mode

;; I'm so used to lovely org mode tables, I need them everywhere!
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

;; Sometimes I need to copy whole columns too:
;; via [[https://emacs.stackexchange.com/questions/28270/how-to-select-and-copy-a-column-of-an-org-table-without-rectangle-selection][stackoverflow]]

(defun org-table-goto-col-beginning ()
  "Go to beginning of current column and return `point'."
  (interactive)
  (assert (org-table-p) "Not in org-table.")
  (org-table-align)
  (let ((col (org-table-current-column)))
    (goto-char (org-table-begin))
    (org-table-goto-column col))
  (point))

(defun org-table-col-beginning ()
  "Return beginning position of current column."
  (save-excursion
    (org-table-goto-col-beginning)))

(defun org-table-goto-col-end ()
  "Goto end of current column and return `point'."
  (interactive)
  (assert (org-table-p) "Not in org-table.")
  (org-table-align)
  (let ((col (org-table-current-column)))
    (goto-char (1- (org-table-end)))
    (org-table-goto-column col)
    (skip-chars-forward "^|"))
  (point))

(defun org-table-col-end ()
  "Return end position of current column."
  (save-excursion
    (org-table-goto-col-end)))

(defun org-table-select-col ()
  "Select current column."
  (interactive)
  (set-mark (org-table-col-beginning))
  (org-table-goto-col-end)
  (rectangle-mark-mode))

(defun org-table-copy-col ()
  "Copy current column."
  (interactive)
  (org-table-select-col)
  (sit-for 0.2 t)
  (copy-rectangle-as-kill (org-table-col-beginning) (org-table-col-end)))

(with-eval-after-load "org"
  (add-hook 'org-mode-hook
            (lambda ()
              (local-set-key (kbd "C-c o") 'org-table-copy-col)
              (local-set-key (kbd "C-c c") 'tvd-copy-org-table-cell))))

;; eval-after-load 'orgtbl doesn't work
(add-hook 'orgtbl-mode-hook '(lambda ()
                               (define-key orgtbl-mode-map (kbd "C-c o") 'org-table-copy-col)
                               (define-key orgtbl-mode-map (kbd "C-c c") 'tvd-copy-org-table-cell)))

;; integers, reals, positives, set via custom
(setq org-table-number-regexp "^[-+]?\\([0-9]*\\.[0-9]+\\|[0-9]+\\.?[0-9]*\\)$")

;; table hydras, maybe better than aliases?!
(defhydra hydra-org-tables (:color blue)
  "
^Sort by^             ^Transform to^      ^Copy/Del what^       ^Modify^                 ^Outside Org^
^^^^^^^^----------------------------------------------------------------------------------------------------------
_sa_:  alphanumeric   _tc_: CSV           _cl_: Copy Column     _cd_: Delete Column      _ot_: Table to Org Mode
_sA_: -alphanumeric   _te_: Excel         _cc_: Copy Cell       _ci_: Insert Column      _oe_: Enable Org-Tbl Mode
_si_:  ip             _tl_: Latex         _dd_: Delete Cell     _rd_: Delete Row
_sI_: -ip             _th_: HTML          _dc_: Delete Column   _ri_: Insert Row
_sn_:  numeric        _tt_: Tab           _dr_: Delete Row      _li_: Insert Line
_sN_: -numeric        _ta_: Aligned       ^^                    _tr_: Transpose Table
_st_:  time
_sT_: -time           ^^                  ^^                    ^^                       _q_: Cancel


"
  ("sa" sort-table-alphanumeric )
  ("sA" sort-table-alphanumeric-desc)
  ("si" sort-table-ip)
  ("sI" sort-table-ip-desc )
  ("sn" sort-table-numeric )
  ("sN" sort-table-numeric-desc )
  ("st" sort-table-time )
  ("sT" sort-table-time-desc )

  ("tc" table-to-csv)
  ("te" table-to-excel   )
  ("tl" table-to-latex   )
  ("th" table-to-html    )
  ("tt" table-to-csv-tab )
  ("ta" table-to-aligned )

  ("cl" org-table-copy-col )
  ("cc" tvd-copy-org-table-cell)
  ("dd" org-table-blank-field)
  ("dr" nil)
  ("dc" nil)

  ("cd" org-table-delete-column)
  ("ci" org-table-insert-column)
  ("rd" org-table-kill-row)
  ("ri" org-table-insert-row)
  ("li" org-table-hline-and-move)
  ("tr" org-table-transpose-table-at-point)

  ("ot" tablify )
  ("oe" orgtbl-mode)

  ("q" nil :color red))

;; allow me to insert org tables everywhere on request
(defalias 'table     'hydra-org-tables/body)
(global-set-key (kbd "C-c t") 'hydra-org-tables/body)

;; *** org mode slideshows

;; Making presentations within emacs with org mode is cool as well.

(require 'org-present)
(require 'darkroom) ;; hides distractions

;; showtime helpers
(defun slide-return-to-present ()
  "wherever we are, go back to slideshow"
  (interactive)
  (switch-to-buffer-other-window "*slide*")
  (delete-other-windows))

(defun slide-split-to-past ()
  "split slide show and show previous buffer next to it"
  (interactive)
  (split-window-horizontally)
  (other-window 1)
  (if (get-buffer "*eshell*")
      ;; if there's no eshell running, start it, otherwise switch to it
      (switch-to-buffer "*eshell*")
    (eshell)))

;; org present config
(eval-after-load "org-present"
  '(progn
     (add-hook 'org-present-mode-hook
               (lambda ()
                 (org-present-big)
                 (org-display-inline-images)
                 (org-present-hide-cursor)
                 (org-present-read-only)

                 ;; some opticals
                 (setq org-hide-emphasis-markers t)
                 (font-lock-add-keywords 'org-mode
                                         '(("^ +\\([-*]\\) "
                                            (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
                 ;; keys
                 (define-key org-present-mode-keymap [down]    'org-present-next)
                 (define-key org-present-mode-keymap [up]      'org-present-prev)
                 (define-key org-present-mode-keymap (kbd "q") 'org-present-quit)
                 (global-set-key (kbd "C-c p") 'slide-return-to-present) ; used inside eshell to return to slide
                 (define-key org-present-mode-keymap (kbd "s") 'slide-split-to-past)
                 (setq current-buffer (buffer-name)) ; remember slide buffer name
                 (rename-buffer "*slide*")
                 ;;(darkroom-tentative-mode)
                 ))

     (add-hook 'org-present-mode-quit-hook
               (lambda ()
                 (org-present-small)
                 (org-remove-inline-images)
                 (org-present-show-cursor)
                 (org-present-read-write)
                 (setq org-hide-emphasis-markers nil)
                 (rename-buffer current-buffer)
                 (global-unset-key (kbd "C-c p"))
                 ;;(darkroom-tentative-mode)
                 ))))

;; Will be inserted as first help slide in a slide show
;; (edit table in org-mode!)
(defun slide-header (prefix)
  (interactive "P")
  (save-excursion
    (if (eq prefix nil)
        ()
      (goto-char (point-min)))
    (insert "\n* ORG-MODE slide show commands

  | Key   | Command                                                    |
  +-------+------------------------------------------------------------+
  | C-p   | start slide show                                           |
  | q     | stop slide show                                            |
  | s     | slit window and switchto or start eshell                   |
  | C-c p | while in split mode, return to full screen slide show      |
  | C-c r | enter window resize mode, use cursor keys, <ret> to finish |
  | C--   | (CTRL and minus) shrink font size                          |
  | C-+   | (CTRL and plus) increase font size                         |

")))


;; --------------------------------------------------------------------------------
;; *** outshine mode

;; I maintain my emacs config with  outshine mode. It works a lot like
;; org mode, but I still have a  normal emacs lisp buffer, which I can
;; use directly without  any conversion beforehand and  which works if
;; outshine is  not installed. Also  I thing "literal  programming" is
;; bullshit.

(require 'outshine)

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
    (if (string= "" outshine-normalized-outline-regexp-base)
        (call-interactively 'imenu) ;; use imenu outside outshine
      (when (or (not tvd-headings)
                (buffer-modified-p))
        (tvd-outshine-parse-headings))
      (if (not tvd-headings)
          (message "Could not parse headings")
        (setq heading (ido-completing-read
                       "Jump to heading: "
                       (tvd-alist-keys tvd-headings)))
        (when heading
          (show-all)
          (goto-char (cdr (assoc heading tvd-headings)))
          (tvd-outshine-sparse-tree))))))


(defun tvd-outshine-end-of-section ()
  "Jump to the end of an outshine section."
  (interactive)
  (let ((end))
    (outline-show-subtree)
    (save-excursion
      (outline-next-heading)
      (when (outline-on-heading-p)
        (backward-paragraph))
      (setq end (point)))
    (goto-char end)))

;; outshine mode config (inside outline mode)
(eval-after-load "outline"
  '(progn
     (add-hook 'outline-minor-mode-hook
               (lambda ()
                 (defalias 'j    'tvd-outshine-jump)
                 (defalias 'jump 'tvd-outshine-jump)
                 (define-key outline-minor-mode-map (kbd "C-c C-j")  'tvd-outshine-jump)
                 (setq outshine-org-style-global-cycling-at-bob-p t
                       outshine-use-speed-commands t
                       outshine-speed-commands-user
                       (quote (
                               ("v" . outshine-narrow-to-subtree)
                               ("q" . widen)
                               ("e" . tvd-outshine-end-of-section))))))))

;; Narrowing now works within the headline rather than requiring to be on it
(advice-add 'outshine-narrow-to-subtree :before
            (lambda (&rest args) (unless (outline-on-heading-p t)
                                   (outline-previous-visible-heading 1))))

;; convert outshine buffer  to org buffer using outorg,  which is part
;; of outshine.
(defun outshine-to-org ()
  (interactive)
  (outorg-convert-to-org)
  (org-mode))

;; I  use this  to generate  a  HTML version  of my  emacs config  for
;; posting online, which makes it way easier to read.
(defun outshine-to-html (file)
  (interactive
   (list
    (read-file-name "HTML output file: "
                    (expand-file-name "~/D/github/dot-emacs")
                    "emacs.html")))
  (let ((B (current-buffer)))
    (with-temp-buffer
      (insert-buffer-substring B)
      ;; remove 'sk spacings for smaller <pre>'s
      (tvd-replace-all ")\s*;" ") ;")
      ;; highlight at least a little
      (tvd-replace-all "FIXME" "/FIXME/")
      (emacs-lisp-mode)
      (outshine-to-org)
      (org-export-to-file 'html file))))

(defun export ()
  "Export .emacs to git, do not use."
  ;; FIXME: generate version number, add last changelog to git
  (interactive)
  (outshine-to-html "~/D/github/dot-emacs/emacs.html")
  (shell-command "cp ~/.emacs ~/D/github/dot-emacs/")
  (shell-command "cd ~/D/github/dot-emacs && git ci +fixes .emacs emacs.html")
  (shell-command "cd ~/D/github/dot-emacs && git push"))

;; --------------------------------------------------------------------------------

;; *** outline mode

;; I use the very same cycle style  as in org mode: when on a heading,
;; hide it, jump to next heading on the same level and expand that (or
;; vice versa).  however, when NOT on  a heading behave as loved: jump
;; paragraphs.

;; Note, that  this also  affects outshine  mode, since  that inherits
;; from outline.

(defun tvd-outline-left-or-level-up()
  "jump one word to the left if not on a heading,
otherwise fold current level and jump one level up."
  (interactive)
  (if (outline-on-heading-p)
      (progn
        (hide-subtree)
        (outline-up-heading 1))
    (left-word)))

(defun tvd-outline-heading-up()
  "fold current heading, jump one level up and unfold it"
  (interactive)
  (if (not (outline-on-heading-p))
      (backward-paragraph)
    (hide-subtree)
    (outline-backward-same-level 1)
    (outline-cycle)))

(defun tvd-outline-heading-down()
  "fold current heading, jump one level down and unfold it"
  (interactive)
  (if (not (outline-on-heading-p))
      (forward-paragraph)
    (hide-subtree)
    (outline-forward-same-level 1)
    (outline-cycle)))

;; unused, see tvd-outshine-jump
(defun tvd-outline-jump (part)
  "Jump interactively to next header containing PART using search."
  (interactive "Mjump to: ")
  (let ((done nil)
        (pwd (point)))
    (beginning-of-buffer)
    (outline-show-all)
    (when (re-search-forward (format "^;; \\*+.*%s" part) (point-max) t)
      (when (outline-on-heading-p)
        (beginning-of-line)
        (setq done t)))
    (when (not done)
      (message (format "no heading with '%s' found" part))
      (goto-char pwd))))

;; outline mode config
(eval-after-load "outline"
  '(progn
     (add-hook 'outline-minor-mode-hook
               (lambda ()
                 ;; narrowing, we use outshine functions, it's loaded anyway
                 (defalias 'n 'outshine-narrow-to-subtree)
                 (defalias 'w 'widen)
                 (define-key outline-minor-mode-map (kbd "<C-up>")   'tvd-outline-heading-up)
                 (define-key outline-minor-mode-map (kbd "<C-down>") 'tvd-outline-heading-down)
                 (define-key outline-minor-mode-map (kbd "<C-left>") 'tvd-outline-left-or-level-up)))))

;; orange fringe when narrowed
(advice-add 'outshine-narrow-to-subtree :after
            '(lambda (&rest args)
               (set-face-attribute 'fringe nil :background tvd-fringe-narrow-bg)))


;; --------------------------------------------------------------------------------
;; *** narrowing (no mode but fits here)

;; I use narrowing quite frequently, so here are some enhancements.

;; easier narrowing with Indirect Buffers
;; Source: [[https://www.emacswiki.org/emacs/NarrowIndirect3][emacswiki]]
(require 'narrow-indirect)
(defalias 'nf 'ni-narrow-to-defun-indirect-other-window)
(defalias 'nr 'ni-narrow-to-region-indirect-other-window)

;; I  like to  have  an  orange fringe  background  when narrowing  is
;; active, since I forget that it is in effect otherwise sometimes.

;; via [[https://emacs.stackexchange.com/questions/33288/how-to-find-out-if-narrow-to-region-has-been-called-within-save-restriction][stackoverflow]]
(defun tvd-narrowed-fringe-status ()
  "Make the fringe background reflect the buffer's narrowing status."
  (set-face-attribute
   'fringe nil :background (if (buffer-narrowed-p)
                               tvd-fringe-narrow-bg
                             nil)))

(add-hook 'post-command-hook 'tvd-narrowed-fringe-status)

;; --------------------------------------------------------------------------------
;; *** ANSI-TERM (inferior shells/interpreters and REPLs)

;; I use ansi term for inferior shells only.

;; via [[http://echosa.github.io/blog/2012/06/06/improving-ansi-term/][echosa]]

;; kill buffer when done
(defadvice term-sentinel (around tvd-advice-term-sentinel (proc msg))
  (if (memq (process-status proc) '(signal exit))
      (let ((buffer (process-buffer proc)))
        ad-do-it
        (kill-buffer buffer))
    ad-do-it))
(ad-activate 'term-sentinel)

;; force utf8
(defun tvd-term-use-utf8 ()
  (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(add-hook 'term-exec-hook 'tvd-term-use-utf8)

;; make C-y work
(defun tvd-term-paste (&optional string)
                      (interactive)
                      (process-send-string
                       (get-buffer-process (current-buffer))
                       (if string string (current-kill 0))))

;; put all term hooks in here
(defun tvd-term-hook ()
  (goto-address-mode)
  (define-key term-raw-map (kbd "C-y") 'tvd-term-paste)
  (define-key term-raw-map (kbd "C-c C-d") 'kill-this-buffer)
  (define-key term-raw-map (kbd "C-d") 'kill-this-buffer)
  (define-key term-raw-map (kbd "C-c C-l") 'term-line-mode)
  (define-key term-raw-map (kbd "C-k")
    (lambda ()
      (interactive)
      (term-send-raw-string "\C-k")
      (kill-line))))
(add-hook 'term-mode-hook 'tvd-term-hook)

;; via [[https://www.emacswiki.org/emacs/AnsiTermHints#toc4][emacswiki]]:
;; Use to supply commandline arguments to ansi-term
(defun term-with-args (new-buffer-name cmd &rest switches)
  (setq term-ansi-buffer-name (concat "*" new-buffer-name "*"))
  (setq term-ansi-buffer-name (generate-new-buffer-name term-ansi-buffer-name))
  (setq term-ansi-buffer-name (apply 'make-term term-ansi-buffer-name cmd nil switches))
  (set-buffer term-ansi-buffer-name)
  (term-mode)
  (term-char-mode)
  (message "Line mode: C-c C-l, Char mode: C-c C-k, Exit: C-c C-d")
  (switch-to-buffer term-ansi-buffer-name))

;; finally the inferior REPLs:
(defun iperl ()
  "interactive perl (via perlbrew if exist or global)"
  (interactive)
  (let ((perlbrew (expand-file-name "~/perl5/perlbrew/bin/perlbrew")))
    (if (file-exists-p perlbrew)
        (term-with-args "*perlbrew-de0*" perlbrew "exec" "--" "perl" "-de0")
      (term-with-args "*perl-de0*" "perl" "-de0"))))

(defun iruby ()
  "interactive ruby"
  (interactive)
  (term-with-args "*ruby-irb*" "irb"))

(defun ipython ()
  "interactive python"
  (interactive)
  (setenv "PYTHONSTARTUP" (expand-file-name "~/.pythonrc"))
  (term-with-args "*python-i*" "python" "-i"))

(defun icalc ()
  "interactive calc"
  (interactive)
  (term-with-args "*calc*" (expand-file-name "~/bin/calc")))

;; --------------------------------------------------------------------------------

;; *** Puppet

;; adds hook for .pp files
(require 'puppet-mode)

;; --------------------------------------------------------------------------------

;; *** Novel Mode - Screen Reader

;; my own emacs screen reader, very handy to read docs on the road.

(require 'novel-mode)
(global-set-key (kbd "C-c C-n")         'novel-mode)

;; --------------------------------------------------------------------------------

;; *** Macro Math

;; see [[https://github.com/nschum/macro-math.el][macro-math]]

;; perform elisp evaluation/caluclaton directly in the buffer.
;; mark something and hit C-x C-0  (which is a reminder to C-x C-= w/o the shift)

(autoload 'macro-math-eval-and-round-region "macro-math" t nil)
(autoload 'macro-math-eval-region "macro-math" t nil)

(global-set-key (kbd "C-x C-0")         'macro-math-eval-region)

;; --------------------------------------------------------------------------------

;; *** Common-Lisp (SLIME)

;; I'm learing CL with slime, start with M-x slime.

;; INSTALL: (see: [[http://www.jonathanfischer.net/modern-common-lisp-on-linux/)][jonathanfischer.net]]

(setq slimehelper (expand-file-name "~/quicklisp/slime-helper.el"))

(if (file-exists-p slimehelper)
    (progn
      (load slimehelper)

      ;; Replace "sbcl" with the path to your implementation
      (setq inferior-lisp-program "sbcl")

      ;; Stop SLIME's REPL from grabbing DEL,
      ;; which is annoying when backspacing over a '('
      (defun override-slime-repl-bindings-with-paredit ()
        (define-key slime-repl-mode-map
          (read-kbd-macro paredit-backward-delete-key) nil))
      (add-hook 'slime-repl-mode-hook 'override-slime-repl-bindings-with-paredit)))

;; --------------------------------------------------------------------------------

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
     (require 'info+)))

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

;; --------------------------------------------------------------------------------

;; *** calc et al.

;; emacs provides 4 ways to calculate:

;; M-x calc:
;; RPN calc with stack. Enter numbers, when done, operator, enter, etc
;; heavy duty.

;; provided by calc:

;; #+BEGIN_SRC
;; (defun c (expr)
;;   (interactive "Mcalc:")
;;   (message (format "result: %s" (calc-eval expr))))
;; #+END_SRC

;; by calc as well, but with algebraic input, access last result with $
;; algebraic == 1 +1 / 3. result will stored in kill-ring, use C-y to paste
(defalias 'c         'quick-calc)

;; M-x calculator
;; interactive, simpler than calc, but comprehensive nevertheless, input
;; is algebraic as well, but last result can be used just as ~/bin/calc

;; lisp can be used to calc as well:
;; M-x evaluate-expression <ret> (+ 1 2) <ret>

;; or, inferior perl calc: M-x icalc, see above

;; --------------------------------------------------------------------------------

;; *** MACROs

;; help: [[https://www.emacswiki.org/emacs/KeyboardMacrosTricks][emacswiki macro tricks]].

;; Default keybindings:
;; start-kbd-macro default binding: ‘C-x (’     — Starts recording a keyboard macro.
;; end-kbd-macro default binding: ‘C-x )’       — Ends recording of a keyboard macro.
;; call-last-kbd-macro default binding: ‘C-x e’ — Executes the last keyboard macro defined.

;; however, I use [[https://github.com/Silex/elmacro][elmacro]].

(require 'elmacro)
(elmacro-mode)

(setq tvd-macro-name "last-macro")

;; ignore stuff
(add-to-list 'elmacro-unwanted-commands-regexps "^(mouse.*)$")
(add-to-list 'elmacro-unwanted-commands-regexps "^(tvd-start-or-stop-macro)$")

(defun tvd-get-macro-name()
  "Ask for a macro name, check for duplicates.
If the given name is already defined, ask again (and again until unique).
If a buffer with the given name exists, kill it (that is, the buffer is
there but has not been saved or evaluated yet). Return the name as string."
  (interactive)
  (let ((done nil)
        (name nil)
        (mbuf nil)
        (err ""))
    (while (not done)
      (setq name (read-string (format "%s - enter macro name (last-macro): " err) nil nil "last-macro"))
      (if (fboundp (intern name))
          (setq err (format "macro '%s is already defined" name))
        (setq mbuf (format "* elmacro - %s *" name))
        (if (get-buffer mbuf)
            (with-current-buffer mbuf
              (kill-buffer mbuf)))
        (setq done t)))
    name))

(defun tvd-get-exec-macro-name()
  "Ask for a macro name to be executed"
  (interactive)
  (let ((macros ())
        (N 1)
        (S nil)
        (T ""))
    (dolist (entry (cdr (assoc tvd-macro-file load-history )))
      (setq S (cdr entry))
      (setq T (symbol-name S))
      (push (list T N) macros)
      (setq N (1+ N)))
    (completing-read "enter macro name: " macros nil t nil)))

;; the heart of my elmacro stuff
(defun tvd-start-or-stop-macro()
  "start macro or stop if started"
  (interactive)
  (if (eq defining-kbd-macro nil)
      (progn
        (elmacro-clear-command-history)
        (start-kbd-macro nil)
        (message "Recording macro. Finish with <shift-F6> ..."))
    (progn
      (call-interactively 'end-kbd-macro)
      (setq tvd-macro-name (tvd-get-macro-name))
      (elmacro-show-last-macro tvd-macro-name)
      (message "Recording done. Execute with <C-F6>, save or <C-x C-e> buffer..."))))

;; better than the default function
(defun tvd-exec-last-macro(&optional ARG)
  "execute last macro (or ARG, if given) repeatedly after every
<ret>, abort with C-g or q, and repeat until EOF after pressing a.

If macro defun is known (i.e. because you evaluated the elmacro buffer
containing the generated defun), it will be executed. Otherwise the
last kbd-macro will be executed."
  (interactive)
  (let ((melm-count 0)
        (melm-all nil)
        (melm-abort nil)
        (melm-beg (eobp))
        (melm-code (or ARG tvd-macro-name)))
    (if (eobp)
        (if (yes-or-no-p "(point) is at end of buffer. Jump to top?")
            (goto-char (point-min))))
    (while (and (not melm-abort)
                (not (eobp)))
       (when (not melm-all)
         (message (concat
                   (format
                    "Executing last macro '%s (%d). Keys:\n"  melm-code melm-count)
                   "<enter>      repeat once\n"
                   "a            repeat until EOF\n"
                   "e            enter macro name to execute\n"
                   "<C-g> or q   abort ..\n "))
         (setq K (read-event))
         (cond ((or (eq K 'return) (eq K 'C-f6)) t)
               ((equal (char-to-string K) "q") (setq melm-abort t))
               ((equal (char-to-string K) "a") (message "Repeating until EOF")(setq melm-all t))
               ((equal (char-to-string K) "e") (setq tvd-macro-name (tvd-get-exec-macro-name)))
               (t (setq melm-abort t))))
       (if (not melm-abort)
           (progn
             (if (fboundp (intern melm-code))
                 (call-interactively (intern melm-code))
               (call-interactively 'call-last-kbd-macro))
             (setq melm-count (1+ melm-count)))))
    (if (and (eq melm-count 0) (eq (point) (point-max)))
        (message "(point) is at end of buffer, aborted")
      (message (format "executed '%s %d times" melm-code melm-count)))))

;; My macro recording workflow:
;; - shift-F6
;; - ... do things  ...
;; - shift-F6 again
;; - enter a  name
;; - a new buffer with macro defun appears
;; - C-x C-e evals it
;; - C-F6 (repeatedly) executes it.
(global-set-key (kbd "<f6>")            'tvd-start-or-stop-macro)
(global-set-key (kbd "<C-f6>")          'tvd-exec-last-macro)

;; I use my own macro file
(setq tvd-macro-file (concat tvd-lisp-dir "/macros.el"))

;; but only load if in use
(if (file-exists-p tvd-macro-file)
    (load-file tvd-macro-file))

(defun tvd-macro-store()
  "store current macro to emacs config"
  (interactive)
  (copy-region-as-kill (point-min) (point-max))
  (if (not (get-buffer "macros.el"))
      (find-file tvd-macro-file))
  (with-current-buffer "macros.el"
    (goto-char (point-max))
    (newline)
    (insert ";;")
    (newline)
    (insert (format ";; elmacro added on %s" (current-time-string)))
    (newline)
    (yank)
    (newline)
    (save-buffer))
  (switch-to-buffer nil)
  (delete-window))

(defalias 'ms        'tvd-macro-store)

(defun tvd-macro-gen-repeater-and-save()
  "generate repeater and save the defun's
Runs when (point) is at 0,0 of generated
defun."
  (next-line)
  (goto-char (point-max))
  (newline)
  (insert (format "(defun %s-repeat()\n" tvd-macro-name))
  (insert "  (interactive)\n")
  (insert (format "  (tvd-exec-last-macro \"%s\"))\n" tvd-macro-name))
  (newline)
  (eval-buffer)
  (tvd-macro-store))

(advice-add 'elmacro-show-defun :after '(lambda (&rest args)
                                          (tvd-macro-gen-repeater-and-save)))

;; --------------------------------------------------------------------------------
;; *** EWW browser stuff

;; Emacs has a builtin browser, which is not too bad.

(require 'eww)

;; see also: shr-render-[buffer|region] !
(defun eww-render-current-buffer ()
  "Render HTML in the current buffer with EWW"
  (interactive)
  (beginning-of-buffer)
  (eww-display-html 'utf8 (buffer-name)))

(defalias 'render-html 'eww-render-current-buffer)

;; eww config
(add-hook 'eww-mode-hook #'toggle-word-wrap)
(add-hook 'eww-mode-hook #'visual-line-mode)

;; custom short commands, see ? for the defaults
(define-key eww-mode-map "o" 'eww) ; aka other page
(define-key eww-mode-map "f" 'eww-browse-with-external-browser) ; aka firefox
(define-key eww-mode-map "j" 'next-line)
(define-key eww-mode-map "r" 'eww-reload)
(define-key eww-mode-map "s" 'shr-save-contents)
(define-key eww-mode-map "v" 'eww-view-source)
(define-key eww-mode-map "b" 'eww-add-bookmark)
(define-key eww-mode-map "p" 'eww-back-url)
(define-key eww-mode-map "n" 'eww-forward-url)

;; link short commands
(define-key eww-link-keymap "c" 'shr-copy-url)
(define-key eww-link-keymap "s" 'shr-save-contents)

;; FIXME:  latest GIT  version  of eww  contains 'eww-readable,  which
;; hides menus and distractions! Update emacs.


;; --------------------------------------------------------------------------------
;; *** Firestarter

;; experimental: do things on save buffer etc.
;; Source: [[https://github.com/wasamasa/firestarter][firestarter]]

;; *** Tabulated List Mode
;; built-in, used by many interactive major modes

;; +tablist, which provides many cool features
;; [[https://github.com/politza/tablist][github source]]
;; important commands:
;; - <  shrink column
;; - >  enlarge column
;; - s  sort column
;; - /  prefix for filter commands
;;   / e   edit filter, e.g. do not list auto-complete sub-packages in melpa:
;;   / a  ! Package =~ ac- <ret>
(require 'tablist)

;; we need to kill tablist's binding in order to have ours run (see below)
(define-key tablist-minor-mode-map (kbd "q") nil)
(define-key tablist-minor-mode-map (kbd "q") 'tvd-close-window)

(defun tvd-close-window ()
  (interactive)
  (kill-this-buffer)
  (delete-window))

(eval-after-load "tabulated-list"
  '(progn
     (add-hook 'tabulated-list-mode-hook
               (lambda ()
                 (tablist-minor-mode)
                 (local-set-key (kbd "Q") 'delete-other-windows)
                 (hl-line-mode)))))

;; *** Help Mode

;; I even customize help windows! ... at least a little :)

(eval-after-load "Help"
  '(progn
     (add-hook 'help-mode-hook
               (lambda ()
                 (local-set-key (kbd "q") 'tvd-close-window)
                 (local-set-key (kbd "x") 'quit-window)
                 (local-set-key (kbd "p") 'help-go-back)
                 (local-set-key (kbd "b") 'help-go-back)
                 (local-set-key (kbd "n") 'help-go-forward)
                 (local-set-key (kbd "f") 'help-go-forward)
                 ))))

;; *** Suggest Mode

;; [[https://github.com/Wilfred/suggest.el][suggest mode]] is a great
;; elisp development tool. Execute `M-x suggest' and try it.

(require 'suggest) ;; depends on dash, s, f, loop

;; I use my own clearing function, since suggest doesn't provide this
(defun tvd-suggest-reload ()
  "Clear suggest buffer and re-paint it."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (suggest--insert-heading suggest--inputs-heading)
    (insert "\n\n\n")
    (suggest--insert-heading suggest--outputs-heading)
    (insert "\n\n\n")
    (suggest--insert-heading suggest--results-heading)
    (insert "\n")
    (suggest--nth-heading 1)
    (forward-line 1)))

(defun tvd-suggest-jump ()
  "Jump between input and output suggest buffer."
  (interactive)
  (forward-line -1)
  (if (eq (line-number-at-pos) 1)
      (suggest--nth-heading 2)
    (suggest--nth-heading 1))
  (forward-line 1))

(eval-after-load "suggest"
  '(progn
     (add-hook 'suggest-mode-hook
               (lambda ()
                 (local-set-key (kbd "C-l") 'tvd-suggest-reload)
                 (local-set-key (kbd "<tab>") 'tvd-suggest-jump)))))

;; *** Followcursor Mode

;; [[https://github.com/TLINDEN/followcursor-mode][source on github]]

;; From time to time I need to  refactor configs and the like based on
;; lists. For example  in the left window  I have a list  of bgp peers
;; and in the right window a config file for all peers which I have to
;; modify based on current settings.  With followcursor-mode I can put
;; point on an  ip address and the line in  the config containing this
;; ip address  will be highlighted. If  I move on to  the next address
;; the next line on the right will be highlighted.

;; The mode is a work-in-progress...

(require 'followcursor-mode)



;; *** Magit

;; Not much to  say about Magit
(unless tvd-win-home
  (setq tvd-magit-revision "20170725.1153")

  (add-to-list 'load-path (concat tvd-lisp-dir (concat "/magit-" tvd-magit-revision)))

  (require 'magit)

  (defun tvd-magit-status ()
    "Always call `magit-status' with prefix arg."
    (interactive)
    (let ((current-prefix-arg t))
      (call-interactively 'magit-status)))

  (with-eval-after-load 'info
    (info-initialize)
    (add-to-list 'Info-directory-list
                 (expand-file-name (concat "~/.emacs.d/lisp/magit-"
                                           tvd-magit-revision
                                           "/Documentation/")))
    (setq magit-view-git-manual-method 'woman))

  (defalias 'git       'magit-status)
  (defalias 'gitlog    'magit-log-buffer-file)

  ;; configure magit
  (with-eval-after-load 'magit
    (dolist (dir (list (expand-file-name "~/D/github")
                       (expand-file-name "~/dev/git")))
      (when (file-exists-p dir)
        (add-to-list 'magit-repository-directories (cons dir 1))))
    (setq magit-completing-read-function 'magit-ido-completing-read)
    ;; navigate magit buffers as I do everywhere else, I do not automatically
    ;; cycle/decycle though, the magit defaults are absolutely sufficient.
    (define-key magit-mode-map (kbd "<C-down>") 'magit-section-forward-sibling)
    (define-key magit-mode-map (kbd "<C-up>")   'magit-section-backward-sibling)
    (define-key magit-mode-map (kbd "<delete>") 'magit-delete-thing))

  ;; one thing though:  on startup it bitches about git  version, but it
  ;; works nevertheless. So I disable this specific warning.

  (defun tvd-ignore-magit-warnings-if-any ()
    (interactive)
    (when (get-buffer "*Warnings*")
      (with-current-buffer "*Warnings*"
        (goto-char (point-min))
        (when (re-search-forward "Magit requires Git >=")
          (kill-buffer-and-window)))))

  (add-hook 'after-init-hook 'tvd-ignore-magit-warnings-if-any t)

  ;; now, THIS is the pure genius me: hit "ls in magit-status buffer
  ;; and end up in a dired buffer of current repository. The default
  ;; binding for this is C-M-i, which is not memorizable, while "ls"
  ;; is. That is, 'l' is a prefix command leading to magit-log-popup
  ;; and 's' is undefined, which I define here, which then jumps to
  ;; dired.
  (magit-define-popup-action 'magit-log-popup
    ?s "Dired" 'magit-dired-jump)

  ;; after an exhausting discussion on magit#3139 I use this function
  ;; to (kind of) switch to another repository from inside magit-status.
  (defun tvd-switch-magit-repo ()
    (interactive)
    (let ((dir (magit-read-repository)))
      (magit-mode-bury-buffer)
      (magit-status dir)))
  (define-key magit-mode-map (kbd "C") 'tvd-switch-magit-repo))

;; --------------------------------------------------------------------------------
;; *** Dired

;; I use dired  for two things: from inside magit  as a convenient way
;; to add or remove files from a  repository. Or if I want to rename a
;; bunch of files using search/replace and other editing commands.

;; But as with everything else I use,  it must fit and so I managed to
;; tune this as well.

;; [[http://ergoemacs.org/emacs/emacs_dired_tips.html][More Hints]]

;; **** dired-k

;; dired-k is k  for dired/emacs: it colorizes files  and directory by
;; age, that is, the older the  greyer they get. And it displays flags
;; about the git status of each file, which is really handy.

(require 'dired-k)

(add-hook 'dired-initial-position-hook 'dired-k)
(add-hook 'dired-after-readin-hook #'dired-k-no-revert)

(setq dired-k-padding 2)

;; **** dired-hacks

;; [[https://github.com/Fuco1/dired-hacks][Fuco1s dired-hacks]] is a
;; place to find the really cool stuff, I mostly use the filters.
(require 'dired-filter)

(defun tvd-dired-quit-or-filter-pop (&optional arg)
  "Remove a filter from the filter stack. If none left, quit the dired buffer."
  (interactive "p")
  (if dired-filter-stack
      (dired-filter-pop arg)
    (quit-window)))

(require 'dired-ranger)

;; **** dired sort helpers

;; This sort function by [[http://ergoemacs.org/emacs/dired_sort.html][Xah Lee]]
;; is easy to use and does what it should, great!, However, I added some -desc
;; sister sorts for reverse sorting.
(defun xah-dired-sort ()
  "Sort dired dir listing in different ways.
Prompt for a choice.
URL `http://ergoemacs.org/emacs/dired_sort.html'
Version 2015-07-30"
  (interactive)
  (let (sort-by arg)
    (setq sort-by (ido-completing-read "Sort by:" '( "date" "size" "name" "dir" "date-desc" "size-desc" "name-desc" "dir-desc" )))
    (cond
     ((equal sort-by "name") (setq arg "-Al --si --time-style long-iso "))
     ((equal sort-by "date") (setq arg "-Al --si --time-style long-iso -t"))
     ((equal sort-by "size") (setq arg "-Al --si --time-style long-iso -S"))
     ((equal sort-by "dir") (setq arg "-Al --si --time-style long-iso --group-directories-first"))
     ((equal sort-by "name-desc") (setq arg "-Al --si --time-style long-iso -r"))
     ((equal sort-by "date-desc") (setq arg "-Al --si --time-style long-iso -t -r"))
     ((equal sort-by "size-desc") (setq arg "-Al --si --time-style long-iso -S -r"))
     ((equal sort-by "dir-desc") (setq arg "-Al --si --time-style long-iso --group-directories-first -r"))
     (t (error "logic error 09535" )))
    (dired-sort-other arg )))

;; **** dired git helpers

;; [[http://blog.binchen.org/posts/the-most-efficient-way-to-git-add-file-in-dired-mode-emacsendiredgit.html][via bin chen]]:
;; make git commands available from dired  buffer, which can be used in
;; those rare cases, where my wrappers below don't fit.
(defun diredext-exec-git-command-in-shell (command &optional arg file-list)
  "Run a shell command git COMMAND  ' on the marked files.  if no
files marked, always operate on current line in dired-mode"
  (interactive
   (let ((files (dired-get-marked-files t current-prefix-arg)))
     (list
      ;; Want to give feedback whether this file or marked files are used:
      (dired-read-shell-command "git command on %s: " current-prefix-arg files)
      current-prefix-arg
      files)))
  (unless (string-match "[?][ \t]\'" command)
    (setq command (concat command " *")))
  (setq command (concat "git " command))
  (dired-do-shell-command command arg file-list)
  (message command))

;; some git  commandline wrappers  which directly  work on  git files,
;; called with "hydras".
(defun tvd-dired-git-add(&optional arg file-list)
  "Add marked or current file to current repository (stash)."
  (interactive
    (let ((files (dired-get-marked-files t current-prefix-arg)))
      (list current-prefix-arg files)))
  (dired-do-shell-command "git add -v * " arg file-list)
  (revert-buffer))

(defun tvd-dired-git-rm(&optional arg file-list)
  "Remove marked or current file from current repository and filesystem."
  (interactive
   (let ((files (dired-get-marked-files t current-prefix-arg)))
     (list current-prefix-arg files)))
  (dired-do-shell-command "git rm -rf * " arg file-list)
  (revert-buffer))

(defun tvd-dired-git-ungit(&optional arg file-list)
  "Like `tvd-dired-git-rm' but keep the files in the filesystem (unstage)."
  (interactive
   (let ((files (dired-get-marked-files t current-prefix-arg)))
     (list current-prefix-arg files)))
  (dired-do-shell-command "git rm -rf --cached * " arg file-list)
  (revert-buffer))

;; **** dired navigation

;; I'm used to jump around with pos1+end
(defun tvd-dired-begin ()
  "Move point to the first directory in the listing .."
  (interactive)
  (goto-char (point-min))
  (dired-next-dirline 2))

(defun tvd-dired-end ()
  "Move point to the last file or directory in the listing."
  (interactive)
  (goto-char (point-max))
  (dired-previous-line 1))

;; **** dired buffer names

;; This took  me a long time  to figure out,  but I finally got  it: I
;; really  hate it  how  dired names  its buffers,  it  just uses  the
;; basename part of  the current working directory as  buffer name. So
;; when there are  a couple of dozen  buffers open and one  of them is
;; named "tmp"  I just can't see  it. So what  I do here is  to rename
;; each   dired  buffer   right   after  its   creation  by   advising
;; `dired-internal-noselect'. My  dired buffers  have such  names now:
;; *dired: ~/tmp*. I  can find them easily, and I  can reach all dired
;; buffers very  fast thanks to  the *dired  prefix. And they  are now
;; clearly  marked  as  non-file  buffers. In  fact  I  consider  this
;; behavior as a bug, but I doubt many people would agree :)

(advice-add 'dired-internal-noselect
            :filter-return
            '(lambda (buffer)
               "Modify dired buffer names to this pattern: *dired: full-path*"
               (interactive)
               (with-current-buffer buffer
                 (rename-buffer (format "*dired: %s*" default-directory)))
               buffer))

;; **** dired config and key bindings

;; and finally put everything together.

(eval-after-load 'dired
  '(progn
     ;; stay  with 1  dired buffer  per instance
     ;; when changing directories
     (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
     (define-key dired-mode-map (kbd "<C-right>") 'dired-find-alternate-file)
     (define-key dired-mode-map (kbd "^") (lambda () (interactive) (find-alternate-file "..")))
     (define-key dired-mode-map (kbd "<C-left>") (lambda () (interactive) (find-alternate-file "..")))

     ;; Xah Lee'S custom sort's
     (define-key dired-mode-map (kbd "s") 'xah-dired-sort)

     ;; my git "hydras"
     (define-prefix-command 'tvd-dired-git-map)
     (define-key dired-mode-map (kbd "g") 'tvd-dired-git-map)
     (define-key tvd-dired-git-map (kbd "a") 'tvd-dired-git-add)
     (define-key tvd-dired-git-map (kbd "d") 'tvd-dired-git-rm)
     (define-key tvd-dired-git-map (kbd "u") 'tvd-dired-git-ungit)

     ;; edit filenames
     (defalias 'edit-dired 'wdired-change-to-wdired-mode)
     (define-key dired-mode-map (kbd "C-c C-c") 'wdired-change-to-wdired-mode)

     ;; dired-hacks filters
     (define-key dired-mode-map (kbd "f") dired-filter-map)
     (define-key dired-mode-map (kbd "q") 'tvd-dired-quit-or-filter-pop)
     (define-key dired-mode-map (kbd "Q") 'dired-filter-pop-all)

     ;; ranger, multi file copy/move
     (define-prefix-command 'tvd-dired-ranger-map)
     (define-key dired-mode-map (kbd "r") 'tvd-dired-ranger-map)
     (define-key tvd-dired-ranger-map (kbd "c") 'dired-ranger-copy)
     (define-key tvd-dired-ranger-map (kbd "p") 'dired-ranger-paste)
     (define-key tvd-dired-ranger-map (kbd "m") 'dired-ranger-move)

     ;; navigation,  use TAB  and C-TAB  to move
     ;; point to  next or prev dir  like in info
     ;; mode, and  HOME+END to reach the  end or
     ;; beginning of the listing.
     (define-key dired-mode-map (kbd "<tab>") 'dired-next-dirline)
     (define-key dired-mode-map (kbd "<C-tab>") 'dired-prev-dirline)
     (define-key dired-mode-map (kbd "<home>") 'tvd-dired-begin)
     (define-key dired-mode-map (kbd "<end>") 'tvd-dired-end)

     ;; overwrite some defaults I do not use anyway
     (define-key dired-mode-map (kbd "n") 'dired-create-directory)))
;; **** Dired Hydra

;; FIXME: not yet customized to fit my own config
(defhydra hydra-dired (:hint nil :color pink)
  "
_+_ mkdir          _v_iew           _m_ark             _(_ details        _i_nsert-subdir    wdired
_C_opy             _O_ view other   _U_nmark all       _)_ omit-mode      _$_ hide-subdir    C-x C-q : edit
_D_elete           _o_pen other     _u_nmark           _l_ redisplay      _w_ kill-subdir    C-c C-c : commit
_R_ename           _M_ chmod        _t_oggle           _g_ revert buf     _e_ ediff          C-c ESC : abort
_Y_ rel symlink    _G_ chgrp        _E_xtension mark   _s_ort             _=_ pdiff
_S_ymlink          ^ ^              _F_ind marked      _._ toggle hydra   \\ flyspell
_r_sync            ^ ^              ^ ^                ^ ^                _?_ summary
_z_ compress-file  _A_ find regexp
_Z_ compress       _Q_ repl regexp

T - tag prefix
"
  ("\\" dired-do-ispell)
  ("(" dired-hide-details-mode)
  (")" dired-omit-mode)
  ("+" dired-create-directory)
  ("=" diredp-ediff)         ;; smart diff
  ("?" dired-summary)
  ("$" diredp-hide-subdir-nomove)
  ("A" dired-do-find-regexp)
  ("C" dired-do-copy)        ;; Copy all marked files
  ("D" dired-do-delete)
  ("E" dired-mark-extension)
  ("e" dired-ediff-files)
  ("F" dired-do-find-marked-files)
  ("G" dired-do-chgrp)
  ("g" revert-buffer)        ;; read all directories again (refresh)
  ("i" dired-maybe-insert-subdir)
  ("l" dired-do-redisplay)   ;; relist the marked or singel directory
  ("M" dired-do-chmod)
  ("m" dired-mark)
  ("O" dired-display-file)
  ("o" dired-find-file-other-window)
  ("Q" dired-do-find-regexp-and-replace)
  ("R" dired-do-rename)
  ("r" dired-do-rsynch)
  ("S" dired-do-symlink)
  ("s" dired-sort-toggle-or-edit)
  ("t" dired-toggle-marks)
  ("U" dired-unmark-all-marks)
  ("u" dired-unmark)
  ("v" dired-view-file)      ;; q to exit, s to search, = gets line #
  ("w" dired-kill-subdir)
  ("Y" dired-do-relsymlink)
  ("z" diredp-compress-this-file)
  ("Z" dired-do-compress)
  ("q" nil)
  ("." nil :color blue))

(define-key dired-mode-map "." 'hydra-dired/body)

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
;; --------------------------------------------------------------------------------
;; *** Projectile
(require 'projectile)
(projectile-mode +1)

(defun tvd-dir-to-projectile ()
    "drop a .projectile wherever we are"
  (interactive)
  (with-temp-file ".projectile"
    (insert "-.snapshot\n-.git\n-.RCS\n"))
  (message (format "Turned %s into projectile project" default-directory)))

(defhydra hydra-projectile
  ( :color teal
    :columns 4)
  "Projectile (use C-p for this menu)"
  ("s"   projectile-switch-project           "Switch Project")
  ("f"   projectile-find-file                "Find File")
  ("r"   projectile-recentf                  "Recent Files")
  ("b"   projectile-ibuffer                  "Show Project Buffers")

  ("g"   projectile-grep                     "Grep")
  ("o"   projectile-multi-occur              "Multi Occur")
  ("d"   projectile-dired                    "Project Dired")
  ("R"   projectile-replace                  "Replace in Project")

  ("C"   projectile-invalidate-cache         "Clear Cache")
  ("t"   projectile-regenerate-tags          "Regenerate Tags")
  ("X"   projectile-cleanup-known-projects   "Cleanup Known Projects")
  ("n"   tvd-dir-to-projectile               "Turn current directory into Projectile")

  ("c"   projectile-commander                "Commander")
  ("k"   projectile-kill-buffers             "Kill Buffers")
  ("q"   nil                                 "Cancel" :color blue))

(global-set-key (kbd "C-p") 'hydra-projectile/body)
(defalias 'p 'hydra-projectile/body)

;; --------------------------------------------------------------------------------
;; ** Emacs Interface
;; *** Parens

;; display matching braces
(show-paren-mode 1)

;; 'mixed: highlight all if the other paren is invisible
;; 'expression: highlight the whole sexp
(setq show-paren-style 'mixed)

;; *** highlight todo keywords (such as FIXME)

;; Absolutely needed!

(require 'fic-mode)
(add-something-to-mode-hooks '(c c++ cperl vala web emacs-lisp ruby python) 'turn-on-fic-mode)

;; --------------------------------------------------------------------------------
;; *** UNDO Tree Mode

;; Better undo, with redo support.

;; C-_   (`undo-tree-undo')
;;   Undo changes.
;;
;; C-:   (`undo-tree-redo')
;;   Redo changes.
;;
;; more: see undo-tree.el
(require 'undo-tree)

;; use always
(global-undo-tree-mode)

;; M-_ catched by Xmonad
(global-set-key (kbd "C-:")             'undo-tree-redo)                                  ; C-: == REDO   C-_ == UNDO

;; --------------------------------------------------------------------------------
;; *** Smarter M-x Mode (smex)

;; This is really cool and I don't know how I could ever live without it.

;; fails @win, so wrap it
(safe-wrap
 (progn
   (require 'smex)
   (smex-initialize)
   (global-set-key (kbd "M-x") 'smex)
   (global-set-key (kbd "M-X") 'smex-major-mode-commands))
 (message "ignoring unsupported smex"))
;; --------------------------------------------------------------------------------

;; *** Smarter Search

;; test, replace isearch-forward-regexp first only.
;; dir: ivy/
(require 'swiper)
(with-eval-after-load 'swiper
  (setq ivy-wrap t)
  (global-set-key "\C-s" 'swiper))

;; *** Which Func
;; display current function - if any - in mode line
(add-something-to-mode-hooks
    '(c c++ cperl vala makefile ruby shell-script python)
    'which-func-mode)

;; --------------------------------------------------------------------------------
;; *** Show current-line in the Fringe
(require 'fringe-current-line)
(global-fringe-current-line-mode 1)

;; also change the color (matching the mode line
(set-face-attribute 'fringe nil :foreground "NavyBlue")

;; --------------------------------------------------------------------------------
;; *** Recent Files

;; You know the  file you edited yesterday had "kri"  in its name, but
;; where was it? You don't remember.  But don't worry, recent files is
;; your friend.  It shows the last  N files you edited  recently.
;; I use it permanently.

;; see also: ido-mode and smex

;; setup
(require 'recentf)
(require 'cl-lib)
(setq recentf-auto-cleanup 'never) ;; avoid stat() on tramp buffers
(recentf-mode 1)

;; I like to have a longer list reaching deeper into the past
(setq recentf-max-menu-items 200
      recentf-max-menu-items 30)

;; enable IDO completion
;; via [[http://emacsredux.com/blog/2013/04/05/recently-visited-files/][emacsredux]]
;; modified to exclude already visited files
(defun tvd-buffer-exists-p (bufname)
  (not (eq nil (get-file-buffer bufname))))

(defun recentf-ido-find-file ()
  "Find a recent file using ido."
  (interactive)
  (let ((file (ido-completing-read
               "Choose recent file: "
               (cl-remove-if 'tvd-buffer-exists-p recentf-list) nil t)))
    (when file
      (find-file file))))

(global-set-key (kbd "C-x C-r")         'recentf-ido-find-file)                           ; open recent files, same as M-x rf

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
                            '(not (file-readable-p))))

;; --------------------------------------------------------------------------------

;; *** IDO mode

;; There are other completion  enhancement packages available like ivy
;; for example,  but I love IDO  and I am so  used to it, it  would be
;; impossible to  change. So, I'll  stick with  IDO until end  of (my)
;; times.

;; Hint: Use C-f during file selection to switch to regular find-file

;; Basic config
(ido-mode t)
(ido-everywhere nil)
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

;; --------------------------------------------------------------------------------

;; *** Save cursor position

;; So the  next time  I start  emacs and  open a  file I  were editing
;; previously,  (point) will  be  in  the exact  places  where it  was
;; before.

(if (version< emacs-version "25.0")
    (progn
      (require 'saveplace)
      (setq-default save-place t))
  (save-place-mode 1))

;; --------------------------------------------------------------------------------

;; *** DoReMi experimentation

;; I'm not using it a lot, sometimes I tune the background color though.

;; via [[https://www.emacswiki.org/emacs/DoReMi][emacswiki/DoReMi]]
;; cool ones: doremi-buffers, doremi-all-faces-fg+ [s, h]

(require 'doremi)
(require 'doremi-frm)
(require 'doremi-cmd)

;; FIXME: find a good key
(defalias 'cb 'doremi-buffers+)

;; --------------------------------------------------------------------------------
;; *** Hightligt TABs

;; not a mode, but however: higlight TABs in certain modes

(defface extra-whitespace-face
  '((t (:background "pale green")))
  "Used for tabs and such.")

(defvar tvd-extra-keywords
  '(("\t" . 'extra-whitespace-face)))

(add-something-to-mode-hooks '(c c++ vala cperl emacs-lisp python shell-script ruby)
                             (lambda () (font-lock-add-keywords nil tvd-extra-keywords)))

;; --------------------------------------------------------------------------------

;; *** Browse kill-ring

;; when active use n  and p to browse, <ret> to  select, it's the same
;; as <M-y> and I never really use it...

(require 'browse-kill-ring)
(setq browse-kill-ring-highlight-current-entry t
      browse-kill-ring-highlight-inserted-item t)

;; --------------------------------------------------------------------------------

;; *** goto-last-change

;; Very handy, jump to last change[s].

(require 'goto-last-change)

(global-set-key (kbd "C-b")             'goto-last-change)

;; --------------------------------------------------------------------------------

;; *** Bookmarks

;; I use  the builtin bookmark feature  quite a lot and  am happy with
;; it.  Especially at  work, where  many  files are  located in  large
;; path's on remote storage systems, it  great to jump quickly to such
;; places.

;; everytime bookmark is changed, automatically save it
(setq bookmark-save-flag 1
      bookmark-version-control t)

;; I use the same aliases as in apparix for bash (since I'm used to them)
(defalias 'to        'bookmark-jump)
(defalias 'bm        'bookmark-set)
(defalias 'bl        'bookmark-bmenu-list)

;; --------------------------------------------------------------------------------

;; *** which-key

;; One of the  best unobstrusive modes for key help  ever.  Just start
;; entering  a key  chord, prefix  or whatever,  and it  pops a  small
;; buffer (on the right side in my case) showing the avialable keys to
;; press from there along with the associated functions.

(require 'which-key)
(which-key-mode)
(which-key-setup-side-window-right)

;; --------------------------------------------------------------------------------

;; *** iBuffer mode

;; iBuffer is a great interactive buffer management tool included with
;; emacs.   I  use  it  with  a   couple  of  custom  groups,  my  own
;; collapse-code (<TAB>) and formats.

(require 'ibuffer)

;; from github:
(require 'ibuffer-vc)
(require 'ibuffer-tramp)

;; replace default list-buffers with ibuffer
(global-set-key (kbd "C-x C-b")         'ibuffer)

;; group name
(setq tvd-ibuffer-filter-group-name "tvd-filters")

;; filter group config
;; with hints from [[https://ogbe.net/emacsconfig.html][Ogbe]] et.al.
(setq ibuffer-saved-filter-groups
      (list (nreverse
             `(
               ("Org" (mode . org-mode))
               ("Shell" (or (mode . term-mode)
                            (mode . eshell-mode)
                            (mode . shell-mode)))
               ("Emacs-Config"  (filename . "emacs"))
               ("Cisco-Config" (mode . cisco-mode))
               ("Code" (or (mode . cperl-mode)
                           (mode . c-mode)
                           (mode . python-mode)
                           (mode . shell-script-mode)
                           (mode . makefile-mode)
                           (mode . cc-mode)))
               ("Text" (or (mode . text-mode)
                           (filename . "\\.pod$")))
               ("LaTeX" (mode . latex-mode))
               ("Interactive" (or
                               (mode . inferior-python-mode)
                               (mode . slime-repl-mode)
                               (mode . inferior-lisp-mode)
                               (mode . inferior-scheme-mode)
                               (name . "*ielm*")))
               ("Crab" (or
                        (name . "^\\*\\(Help\\|scratch\\|Messages\\)\\*")
                          ))
               ,tvd-ibuffer-filter-group-name))))

;; Reverse the  order of the  filter groups. Kind of  confusing: Since
;; I'm reversing the  order of the groups above,  this snippet ensures
;; that the groups are ordered in the way they are written above, with
;; the "Default" group on top. This  advice might need to be ported to
;; the new advice system soon.

(defadvice ibuffer-generate-filter-groups
    (after reverse-ibuffer-groups () activate)
  (setq ad-return-value (nreverse ad-return-value)))

(defun ibuffer-add-dynamic-filter-groups ()
  (interactive)
  (dolist (group (ibuffer-vc-generate-filter-groups-by-vc-root))
    (add-to-list 'ibuffer-filter-groups group))
  (dolist (group (ibuffer-tramp-generate-filter-groups-by-tramp-connection))
    (add-to-list 'ibuffer-filter-groups group)))

(defun tvd-ibuffer-hooks ()
  (ibuffer-auto-mode 1)
  (ibuffer-switch-to-saved-filter-groups tvd-ibuffer-filter-group-name)
  (ibuffer-add-dynamic-filter-groups))
(add-hook 'ibuffer-mode-hook 'tvd-ibuffer-hooks)

;; Only show groups that have active buffers
(setq ibuffer-show-empty-filter-groups nil)

;; Don't show the summary or headline
(setq ibuffer-display-summary nil)

;; do not prompt for every action
(setq ibuffer-expert t)

;; buffers to always ignore
(add-to-list 'ibuffer-never-show-predicates "^\\*\\(Completions\\|tramp/\\)")

;; Use human readable Size column instead of original one
(define-ibuffer-column size-h
  (:name "Size" :inline t)
  (cond
   ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1000000.0)))
   ((> (buffer-size) 100000) (format "%7.0fk" (/ (buffer-size) 1000.0)))
   ((> (buffer-size) 1000) (format "%7.1fk" (/ (buffer-size) 1000.0)))
   (t (format "%8d" (buffer-size)))))

;; Modify the default ibuffer-formats
(setq ibuffer-formats
      '((mark modified read-only " "
              (name 20 40 :left :elide)
              " "
              (size-h 9 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " "
              filename-and-process)))

;; hide annoying groups, but keep its buffers available
(defvar ibuffer-collapsed-groups (list "Crab"))

(advice-add 'ibuffer :after '(lambda (&rest args)
  (ignore args)
  (save-excursion
    (dolist (group ibuffer-collapsed-groups)
      (ignore-errors
        (ibuffer-jump-to-filter-group group)
        (ibuffer-toggle-filter-group))))))

;; move point to most recent buffer when entering ibuffer
(defadvice ibuffer (around ibuffer-point-to-most-recent) ()
           "Open ibuffer with cursor pointed to most recent (non-minibuffer) buffer name"
           (let ((recent-buffer-name
                  (if (minibufferp (buffer-name))
                      (buffer-name
                       (window-buffer (minibuffer-selected-window)))
                    (buffer-name (other-buffer)))))
             ad-do-it
             (ibuffer-jump-to-buffer recent-buffer-name)))
(ad-activate 'ibuffer)

;; override ibuffer M-o binding
(define-key ibuffer-mode-map (kbd "M-o")    'other-window-or-switch-buffer)


;; --------------------------------------------------------------------------------

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

;; --------------------------------------------------------------------------------
;; *** Beacon mode (pointer blink)
;; Source: [[https://github.com/Malabarba/beacon][beacon mode]]

;; Blink the cursor shortly when  moving across large text sections or
;; when changing  windows. That way it  is easier to find  the current
;; editing position.

(require 'beacon)

(setq beacon-blink-duration 0.1
      beacon-blink-when-point-moves-vertically 10
      beacon-color 0.3)

(add-hook 'beacon-dont-blink-predicates
          (lambda () (bound-and-true-p novel-mode)))

(beacon-mode)

;; --------------------------------------------------------------------------------
;; ** mode-line setup (must be the last mode)

;; I just append the current version  of my emacs config and leave out
;; some stuff  to keep the modeline  short, so that everything  can be
;; seen even if I have multiple windows open.

;; smaller pos
(setq-default mode-line-position
              '((-3 "%p") (size-indication-mode ("/" (-4 "%I")))
                " "
                (line-number-mode
                 ("%l" (column-number-mode ":%c")))))

;; when macro recording is active,  signal it with coloring instead of
;; just a character
(defface rec-face
  '((t (:background "red" :foreground "white" :weight bold)))
  "Flag macro recording in mode-line"
  :group 'tvd-mode-line-faces)

;; custom modeline
(setq-default mode-line-format
              (list
               "%e"
               mode-line-front-space
               mode-line-mule-info
               mode-line-modified
               mode-line-remote
               "  "
               mode-line-buffer-identification
               "  "
               mode-line-position
               " (%m) "

               " [" tvd-emacs-version "] "

               '(:eval (propertize
                        (if (eq defining-kbd-macro t)
                            "[REC]"
                          "")
                        'face 'rec-face))

               mode-line-end-spaces))

;; --------------------------------------------------------------------------------
;; * Emacs Autoconfig / Customizegroup stuff
;; --------------------------------------------------------------------------------
;; ** font faces
;; Font color config, must always be the last thing so all hook faces are loaded.

;; show available colors:
(defalias 'colors 'list-colors-display)


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :width normal))))
 '(cperl-nonoverridable-face ((((class color) (background light)) (:foreground "Magenta"))))
 '(custom-documentation-face ((t (:foreground "Navy"))) t)
 '(custom-group-tag-face-1 ((((class color) (background light)) (:underline t :foreground "VioletRed"))) t)
 '(dired-directory ((t (:inherit font-lock-keyword-face))))
 '(font-lock-builtin-face ((t (:foreground "BlueViolet"))))
 '(font-lock-comment-face ((t (:foreground "DarkGreen"))))
 '(font-lock-constant-face ((t (:foreground "Magenta"))))
 '(font-lock-doc-face ((t (:foreground "DarkOrange3"))))
 '(font-lock-function-name-face ((t (:bold nil :foreground "DarkOrchid"))))
 '(font-lock-keyword-face ((t (:foreground "Blue"))))
 '(font-lock-string-face ((t (:foreground "Red"))))
 '(font-lock-type-face ((t (:foreground "DarkSlateBlue"))))
 '(font-lock-variable-name-face ((t (:foreground "Sienna"))))
 '(font-lock-warning-face ((t (:bold t :foreground "Red"))))
 '(highlight ((t (:background "DarkSeaGreen1"))))
 '(ido-only-match ((t (:foreground "dark green" :weight bold))))
 '(info-title-1 ((t (:inherit outline-1))))
 '(info-title-2 ((t (:inherit outline-2))))
 '(info-title-3 ((t (:inherit outline-3))))
 '(info-title-4 ((t (:inherit outline-4))))
 '(mmm-default-submode-face ((t nil)))
 '(mode-line ((t (:foreground "White" :background "Blue"))))
 '(mode-line-inactive ((t (:foreground "White" :background "DimGray"))))
 '(org-date ((t (:foreground "dark gray" :underline t))))
 '(org-level-1 ((t (:height 1.18 :foreground "medium slate blue" :underline t))))
 '(org-level-2 ((t (:height 1.16 :foreground "sea green" :underline t :weight normal))))
 '(org-level-3 ((t (:height 1.14 :foreground "saddle brown" :underline t))))
 '(org-level-4 ((t (:height 1.12 :foreground "OrangeRed2" :underline t))))
 '(org-level-5 ((t (:height 1.1 :underline t))))
 '(outline-1 ((t (:height 1.2 :inherit font-lock-function-name-face :underline t :weight bold))))
 '(outline-2 ((t (:height 1.15 :inherit font-lock-variable-name-face :underline t :weight bold))))
 '(outline-3 ((t (:height 1.1 :inherit font-lock-keyword-face :underline t :weight bold))))
 '(outline-4 ((t (:height 1.05 :foreground "DodgerBlue3" :underline t))))
 '(region ((t (:foreground "Aquamarine" :background "Darkblue"))))
 '(secondary-selection ((t (:foreground "Green" :background "darkslateblue"))))
 '(wg-command-face ((t nil)))
 '(wg-current-workgroup-face ((t nil)))
 '(wg-divider-face ((t nil)))
 '(wg-filename-face ((t nil)))
 '(wg-frame-face ((t nil)))
 '(wg-message-face ((t nil)))
 '(wg-mode-line-face ((t nil)))
 '(wg-other-workgroup-face ((t nil)))
 '(wg-previous-workgroup-face ((t nil)))
 '(which-func ((t (:background "blue" :foreground "white"))))
 '(which-key-key-face ((t (:weight bold)))))

;; unless we're on windoze
(if (not (null tvd-win-home))
    (set-face-font 'default "Courier New"))

;; --------------------------------------------------------------------------------
;; ** variables

;; If I  ever use custom-group  to customize a  mode, then I  create a
;; manual config  section for  it using the  values, custom  has added
;; here. So, in normal times this should be empty, but needs to exist.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((ruby-indent-level 4)))))

;; ** done

;; Finally, this message is being displayed.  If this isn't the case I
;; know easily that something went wrong.

(message "loading done")
