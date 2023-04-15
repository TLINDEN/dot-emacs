;; *** tramp mode

;; Edit remote files, one of the best things in emacs. I use it every day heavily.

;; Sample: C-x-f /$host:/$file ($host as of .ssh/config or direct, $file including completion)

;; doku: [[http://www.gnu.org/software/tramp/][gnu.org]]
;; use tramp version, see:
;; https://debbugs.gnu.org/cgi/bugreport.cgi?bug=39399

;; (setq tramppkg (expand-file-name "el-get/tramp" tvd-config-dir))

;; doesnt work:
;; FIXME: see current error

;; (el-get-bundle tramp
;;   :type git
;;   :url "https://git.savannah.gnu.org/git/tramp.git"
;;   ;; tramp-loaddefs.el uses `tramp-verion' before it's defined,
;;   ;; work around this by loading trampver.el first.
;;   :autoloads ("trampver.el" "tramp-loaddefs.el")
;;   :checkout "ELPA-2.6.0.3"
;;   :build `(("make" "autoloads")))

;; Current error:
;; Error (el-get): while initializing tramp: Symbol’s function definition
;;  is void: tramp-compat-rx [2 times]

;;; Tramp version fix
;; for  now  I have  to  install  tramp  from elpa  manually,  because
;; use-package doesn't  do it,  since it's  already loaded  on startup
;; (because enabled by default).
;;
;; The el-get  version above doesn't work  as well, it leads  to mixed
;; loading of system tramp and git tramp.
;;
;; FIXME: find out how to force use-package to install and use elpa tramp!
;; (setq tramppkg (expand-file-name "tramp-2.6.0.3" package-user-dir))
;;; (setq tramppkg (expand-file-name "tramp" tvd-sitelisp-dir))

;; (message (format "tramp: installed: %s" (package-installed-p 'tramp)))

(use-package tramp
  ;;:load-path tramppkg
  :ensure nil
  :config
  (setq tramp-default-method "ssh"
        tramp-default-user nil
        ;;tramp-verbose 9
        ido-enable-tramp-completion t))

;; see also backup section in system.el
