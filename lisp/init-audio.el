(use-package emms
  :defer nil

  :config
  (setq emms-source-file-default-directory "~/MP3")
  (emms-add-directory-tree "~/MP3/")
  '(emms-player-mplayer-parameters (quote ("-slave" "-quiet" "-really-quiet" "-novideo")))

  (require 'emms-player-simple)
  (require 'emms-source-file)
  (require 'emms-source-playlist)
  (require 'emms-player-mplayer)

  (emms-all)
  (emms-default-players)

  (defun tvd-emms-beginning-of-song
      (interactive)
    (emms-seek-to '00:00))

  :bind (:map   emms-playlist-mode-map
                ( "<right>" .  'emms-seek-forward)
                ( "<left>" .  'emms-seek-backward)
                ( "<SPC>" . 'emms-pause)
                ( "b" . 'tvd-emms-beginning-of-song)))

(defalias 'audio 'emms)

(provide 'init-audio)
;;; init-audio.el ends here
