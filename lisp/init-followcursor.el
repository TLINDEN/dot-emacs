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

(use-package followcursor-mode
             :ensure nil)



(provide 'init-followcursor)
;;; init-followcursor.el ends here
