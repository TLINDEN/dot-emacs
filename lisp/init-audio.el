(use-package emms
  :defer nil

  :config
  (setq emms-source-file-default-directory "~/MP3"
        emms-playlist-buffer-name "*Music*"
        emms-player-mplayer-parameters '("-slave" "-quiet" "-really-quiet" "-novideo")
        emms-toggle-repeat-playlist t
        emms-toggle-random-playlist nil)

  (emms-add-directory-tree "~/MP3/")

  (require 'emms-player-simple)
  (require 'emms-source-file)
  (require 'emms-source-playlist)
  (require 'emms-player-mplayer)
  (require 'emms-browser)

    (emms-browser-make-filter "recent"
     (lambda (track) (< 30
        (time-to-number-of-days
  (time-subtract (current-time)
                 (emms-info-track-file-mtime track))))))

  (emms-all)
  (emms-default-players)

  (defun tvd-emms-beginning-of-song
      (interactive)
    (emms-seek-to '00:00))

  (defun audio-open-playlist (filename &optional wildcards)
  "makes a new EMMS playlist buffer from the playlist of filename"
  (interactive
   (find-file-read-args "Find file: "
                        (confirm-nonexistent-file-or-buffer)))
  (emms-playlist-new (file-name-base filename))
  (switch-to-buffer (file-name-base filename))
  (emms-playlist-set-playlist-buffer)
  (emms-play-playlist filename))

  :bind (:map   emms-playlist-mode-map
                ( "<right>" .  'emms-seek-forward)
                ( "<left>" .  'emms-seek-backward)
                ( "<SPC>" . 'emms-pause)
                ( "c" . 'emms-playlist-set-playlist-buffer)
                ( "b" . 'tvd-emms-beginning-of-song)))

(defalias 'audio 'emms)

(provide 'init-audio)
;;; init-audio.el ends here
