;;; kage-mode.el --- mode for the kage shader language -*- lexical-binding: t; -*-

;; Copyright (C) 2024, T.v.Dein <tlinden@cpan.org>

;; This file is NOT part of Emacs.

;; This  program is  free  software; you  can  redistribute it  and/or
;; modify it  under the  terms of  the GNU  General Public  License as
;; published by the Free Software  Foundation; either version 3 of the
;; License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT  ANY  WARRANTY;  without   even  the  implied  warranty  of
;; MERCHANTABILITY or FITNESS  FOR A PARTICULAR PURPOSE.   See the GNU
;; General Public License for more details.

;; You should have  received a copy of the GNU  General Public License
;; along  with  this program;  if  not,  write  to the  Free  Software
;; Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
;; USA

;; Version: 0.0.1
;; Package-Version: 20240319.100
;; Author: T.v.Dein <tlinden@cpan.org>
;; Keywords: languages go
;; URL: https://github.com/tlinden/kage-mode
;; License: GNU General Public License >= 3
;; Package-Requires: ((emacs "24.1"))
;; SPDX-License-Identifier: GPL-3.0


;; add dependency
(require 'go-mode)

;; kage-mode is simply derived from go-mode
(define-derived-mode kage-mode go-mode "Kage shader script"
  "Major mode for editing Ebitengine Kage shader files.

This mode provides all the features go-mode provides, since kage files
are go compatible.

It also supports the use of gofmt -s. If you want to use it, add this
to your config:

\(add-hook 'before-save-hook #'kage-gofmt-before-save)"
  ;;; (run-hooks 'kage-mode-hook)
  )

;; we need to have  our own call to gofmt, because  the one in go-mode
;; only works with *.go files, but we use the original call to it anyway
(defun kage-gofmt-before-save ()
  "Execute gofmt, intended to be put into before-safe-hook"
  (interactive)
  (when (eq major-mode 'kage-mode) (gofmt)))

;; autoloaders
(autoload 'kage-mode "kage-mode")
(autoload 'kage-gofmt-before-save "execute gofmt on write")


(provide 'kage-mode)
