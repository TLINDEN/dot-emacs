;; *** tramp mode

;; Edit remote files, one of the best things in emacs. I use it every day heavily.

;; Sample: C-x-f /$host:/$file ($host as of .ssh/config or direct, $file including completion)

;; doku: [[http://www.gnu.org/software/tramp/][gnu.org]]
(setq tramp-default-method "ssh"
      tramp-default-user nil
      tramp-verbose 1
      ido-enable-tramp-completion t)

;; see also backup section in system.el
