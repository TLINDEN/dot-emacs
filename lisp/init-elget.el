;;; setup el-get for non-package modes

;; This MUST be the first init file to be loaded.

;; I use el-get to install  non-(m)elpa packages from github or direct
;; download. That way I don't have to manually keep'em up to date.

(add-to-list 'load-path (expand-file-name "el-get/el-get" tvd-config-dir))

(unless (require 'el-get nil 'noerror)
  (package-refresh-contents)
  (package-install 'el-get)
  (require 'el-get))

(el-get-bundle viking-mode
               :type github
               :pkgname "tlinden/viking-mode"
               :features viking-mode)

(el-get-bundle autoscratch
               :type github
               :pkgname "tlinden/autoscratch"
               :features autoscratch-mode)

(el-get-bundle novel-mode
               :type github
               :pkgname "tlinden/novel-mode"
               :features novel-mode)

(el-get-bundle config-general-mode
               :type github
               :pkgname "tlinden/config-general-mode"
               :features config-general-mode)

(el-get-bundle mark-copy-yank-things-mode
               :type github
               :pkgname "tlinden/mark-copy-yank-things-mode"
               :features mark-copy-yank-things-mode)

(el-get-bundle followcursor-mode
               :type github
               :pkgname "tlinden/followcursor-mode"
               :features followcursor-mode)

(el-get-bundle novel-mode
               :type github
               :pkgname "tlinden/novel-mode"
               :features novel-mode)

(el-get-bundle cisco-mode
               :type http-tar
               :options ("xzf")
               :url "https://www.daemon.de/idisk/Scripts/cisco-mode-0.2.tar.gz")

(el-get-bundle pod-mode
               :type http-tar
               :options ("xzf")
               :url "https://cpan.metacpan.org/authors/id/F/FL/FLORA/pod-mode-1.04.tar.gz")

(el-get-bundle info+
               :type http
               :features info+
               :url "https://www.emacswiki.org/emacs/download/info+.el")

(el-get-bundle narrow-indirect
               :type http
               :features narrow-indirect
               :url "https://www.emacswiki.org/emacs/download/narrow-indirect.el")

(el-get-bundle rotate-text
               :type http
               :url "http://nschum.de/src/emacs/rotate-text/rotate-text.el")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; These packages doesn't install via melpa for unknown reasons
;; see https://github.com/melpa/melpa/issues/8480
;; (el-get-bundle expand-region
;;        :type github
;;        :pkgname "magnars/expand-region.el"
;;        :website "https://github.com/magnars/expand-region.el#readme")

;; ;; same thing, dependes on the latter
;; (el-get-bundle change-inner
;;        :type github
;;        :pkgname "magnars/change-inner.el"
;;        :website "https://github.com/magnars/change-inner.el#readme")

;; (el-get-bundle iedit
;;        :type github
;;        :pkgname "victorhge/iedit"
;;        :website "https://github.com/victorhge/iedit/")

;; (el-get-bundle tablist
;;        :type github
;;        :pkgname "emacsorphanage/tablist"
;;        :website "https://github.com/emacsorphanage/tablist")

(el-get 'sync)


(provide 'init-elget)
;;; init-elget.el ends here
