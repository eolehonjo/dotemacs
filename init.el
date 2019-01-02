;;; package el
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)
;;; use use-package
(require 'use-package)
;;; theme
(use-package atom-one-dark-theme)
;;; font
(let* ((size 15)
       (asciifont "Ricty Diminished Discord")
       (jpfont "Ricty Diminished Discord")
       (h (* size 10))
       (fontspec (font-spec :family asciifont))
       (jp-fontspec (font-spec :family jpfont)))
  (set-face-attribute 'default nil :family asciifont :height h)
  (set-fontset-font nil 'japanese-jisx0213.2004-1 jp-fontspec)
  (set-fontset-font nil 'japanese-jisx0213-2 jp-fontspec)
  (set-fontset-font nil 'katakana-jisx0201 jp-fontspec)
  (set-fontset-font nil '(#x0080 . #x024F) fontspec) 
  (set-fontset-font nil '(#x0370 . #x03FF) fontspec))
;;; company
(use-package company
  :config
  (global-company-mode))
;;; flycheck
(use-package flycheck
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode))
;;; junk file
(use-package open-junk-file
  :bind ("C-c j" . open-junk-file)
  )
;;; elm mode
(use-package elm-mode
  :config
  (setq elm-format-on-save t)
  ;;(setq elm-format-elm-version 0.19)
  )
(use-package flycheck-elm
  :init
  (eval-after-load 'flycheck
     '(add-hook 'flycheck-mode-hook #'flycheck-elm-setup))
)
;;; auto config
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (open-junk-file flycheck-elm flycheck company use-package atom-one-dark-theme org-plus-contrib elm-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
