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

  (defun tvd-emms-beginning-of-song()
      "Jump to beginning of a song"
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

  (defun audio-create-playlist(name)
    "Create a new audio playlist for EMMS player.

It asks interactively for NAME.  The playlistname will be derived
as     this: 'source-file-default-directory + \"playlist-\" + NAME.

If the playlist already exists nothing will be done.

Otherwise the  user will be  asked wether  to add a  directory or
file[s] to  the playlist.  In the  first case  the user  can then
interactively select a directory. In the latter case the user can
add interactively one or more files.

The playlist will be saved when  a directory has been selected or
the user declines to add another file."
    (interactive "sPlaylist name: ")
    (let ((filename (expand-file-name (format "playlist-%s" name) emms-source-file-default-directory)))
      (message filename)
      (if (file-exists-p filename)
          (message (format "Playlist %s already exists!" filename))
        (progn
          (emms-playlist-new name)
          (switch-to-buffer name)
          (emms-playlist-set-playlist-buffer name)
          (let ((read-answer-short t)
                (answer (read-answer "add [D]irectory or [F]ile(s)? "
                                     '(("dir" ?d "add dir")
                                       ("file" ?f "add file")
                                       ("url" ?u "add a streaming url")
                                       ("quit" ?q "quit"))))
                (done nil)
                (abort nil))
            (setq default-directory emms-source-file-default-directory)
            (cond
             ((equal answer "url")
              (let ((url (read-string "Enter a url: ")))
                (when url
                  (emms-add-url url))))
             ((equal answer "dir")
              (while (not done)
                (emms-playlist-set-playlist-buffer name)
                (let ((dir (read-directory-name "Select directory:")))
                  (when dir
                    (emms-add-directory-tree dir))
                  (setq answer (read-char-from-minibuffer "Add another dir [Yn]? "))
                  (when (equal answer ?n)
                    (setq done t)))))
             ((equal answer "file")
              (while (not done)
                (emms-playlist-set-playlist-buffer name)
                (let ((file (read-file-name "Select audio file:")))
                  (when file
                    (emms-add-file file)
                    (setq default-directory (file-name-directory file)))
                  (setq answer (read-char-from-minibuffer "Add another file [Yn]? "))
                  (when (equal answer ?n)
                    (setq done t)))))
             (t (setq abort t)))
            (if abort
                (kill-buffer)
              (progn
                (emms-playlist-save 'native filename)
                (emms-playlist-mode))))))))

  :hook
  (emms-playlist-mode . hl-line-mode)
  (emms-playlist-source-inserted . beginning-of-buffer)

  :bind (:map   emms-playlist-mode-map
                ( "<right>" .  'emms-seek-forward)
                ( "<left>" .  'emms-seek-backward)
                ( "<SPC>" . 'emms-pause)
                ( "b" . 'tvd-emms-beginning-of-song)
                ( "r" . 'emms-toggle-repeat-track)
                ( "R" . 'emms-toggle-repeat-playlist)))

  ;; TODO: check consult-emms functions, already installed with elget)

(defalias 'audio 'emms)

(provide 'init-audio)
;;; init-audio.el ends here
