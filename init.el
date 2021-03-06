;;; package --- @515hikaru emacs initialization

;; Copyright (C) 2019 by Takahiro KOJIMA
;; Author: Takahiro KOJIMA <12kojima.takahiro@gmail.com>
;; URL: https://github.com/515hikaru/dotemacs
;; Version: 0.0.1
;; LICENSE: MIT

;;; Commentary:
;; This package provides Emacs environment for @515hikaru

;;; Code:
;; package el
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)
;;; use use-package
(package-install 'use-package)
(require 'use-package)
(add-to-list 'load-path "~/.emacs.d/my-elisp/")
;;; start up
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
;;; indentation
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(tool-bar-mode 0)
(menu-bar-mode 0)
;;; theme
(use-package atom-one-dark-theme
  :ensure t)
;;; font
(let* ((size 15)
       (asciifont "Ricty")
       (jpfont "Ricty")
       (h (* size 10))
       (fontspec (font-spec :family asciifont))
       (jp-fontspec (font-spec :family jpfont)))
  (set-face-attribute 'default nil :family asciifont :height h)
  (set-fontset-font nil 'japanese-jisx0213.2004-1 jp-fontspec)
  (set-fontset-font nil 'japanese-jisx0213-2 jp-fontspec)
  (set-fontset-font nil 'katakana-jisx0201 jp-fontspec)
  (set-fontset-font nil '(#x0080 . #x024F) fontspec)
  (set-fontset-font nil '(#x0370 . #x03FF) fontspec))
;; no backup
(setq make-backup-files nil)
(setq make-backup-files nil)
;;; exec-path-from-shell
(use-package exec-path-from-shell
  :ensure t)
(when (memq window-system '(mac ns x))
	    (exec-path-from-shell-copy-envs '("PATH" "GOPATH")))
;;; lsp-mode
(use-package lsp-mode
  :ensure t
  :commands lsp)
(use-package company-lsp
  :ensure t)
(use-package lsp-ui
  :ensure t
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))
;;; company
(use-package company
  :ensure t
  :config
  (global-company-mode)
  (push 'company-lsp company-backends))
;;; flycheck
(use-package flycheck
  :ensure t
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode))
;;; magit
(use-package magit
  :ensure t
  :bind ("C-x m" . magit-status))
;;; junk file
(use-package open-junk-file
  :ensure t
  :config (setq open-junk-file-format (concat (getenv "HOME") "/memo/%Y-%m-%d-%H%M%S."))
  :bind ("C-c j" . open-junk-file))
;; python
(use-package python-mode
  :ensure t
  :defer t
  :commands python-mode
  :config
  (add-hook 'python-mode-hook #'lsp))
(use-package conda
  :ensure t
  :init
  (custom-set-variables '(conda-anaconda-home "~/miniconda3"))
  :config
  (conda-env-autoactivate-mode t))
;;; elm environment
(use-package elm-mode
  :ensure t
  :config
  (setq elm-format-on-save t))
(use-package flycheck-elm
  :ensure t
  :init
  (eval-after-load 'flycHeck
     '(add-hook 'flycheck-mode-hook #'flycheck-elm-setup)))
;; golang environment
(use-package go-mode
  :ensure t
  :commands go-mode
  :mode (("\\.go?\\'" . go-mode))
  :defer t
  :init
  (add-hook 'go-mode-hook #'lsp)
  :config
  (setq indent-tabs-mode t)
  (setq c-basic-offset 8)
  (setq tab-width 8)
  (add-hook 'before-save-hook 'lsp-format-buffer))
;; rust environment
(use-package rust-mode
  :ensure t
  :config
  (setq rust-format-on-save t))
(use-package company-racer
  :ensure t
  :defer t
  :init
  (add-hook 'racer-mode-hook #'company-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (add-hook 'rust-mode-hook #'racer-mode)
  :config
  (setq company-tooltip-align-annotations t)
  :bind (:map rust-mode-map
            ("TAB" . #'company-indent-or-complete-common)))
(use-package flycheck-rust
  :ensure t
  :init
  (with-eval-after-load 'rust-mode
    (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)))
(use-package julia-repl
  :ensure t
  :config (add-hook 'julia-mode-hook 'julia-repl-mode))
;;; user function
(defun open-memo-dir()
  "Open memo file directory with dired."
  (interactive)
  (dired "~/memo"))
(use-package neotree
  :ensure t
  :bind ([f8] . 'neotree-toggle)
  :config
  (setq neo-show-hidden-files t)
  (setq neo-smart-open t))
(use-package subr-x)
(defun add--last-slash (str)
  "Add slach end of string"
  (if (string-equal (substring str -1) "/")  ;; get last char
      str
      (concat str "/")))
(defun get--ghq-directory-path()
  "Get ghq root path. if there is not ghq, return HOME directory"
  (if (executable-find "ghq")
      (add--last-slash (string-trim (shell-command-to-string "ghq root")))
    (add--last-slash (getenv "HOME"))))
(defun open-ghq-root()
    "Open ghq root directory with dired."
    (interactive)
    (dired (get--ghq-directory-path)))
(defun edit-init-file()
  "open $HOME/.emacs.d/init.el"
  (interactive)
  (find-file (concat (getenv "HOME") "/.emacs.d/init.el")))
(global-set-key "\C-c\C-e" 'edit-init-file)
(use-package hcl-mode
  :ensure t)
(use-package writeroom-mode
  :ensure t
  :bind ("C-x C-w" . writeroom-mode))
(use-package recentf
  :ensure t
  :bind ("C-x C-r" . 'counsel-recentf)
  :config
  (setq recentf-save-file "~/.emacs.d/.recentf")
  (setq recentf-max-saved-items 200)
  (setq recentf-exclude '(".recentf"))
  (setq recentf-auto-cleanup 'never)
  (run-with-idle-timer 30 t '(lambda () (with-suppressed-message (recentf-save-list)))))
(use-package recentf-ext
  :ensure t)
(use-package counsel
  :ensure t
  :init (ivy-mode 1) ;; デフォルトの入力補完がivyになる
  (counsel-mode 1))
(use-package counsel-ghq
  :bind ("C-x C-q" . 'counsel-ghq))
;;; auto config
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(conda-anaconda-home "~/miniconda3")
 '(package-selected-packages
   (quote
    (solidity-flycheck recentf-ext elm-mode counsel-ghq counsel ivy writeroom-mode hcl-mode subr-x neotree elixir-mode dockerfile-mode toml-mode yaml-mode julia-repl flycheck-julia julia-mode conda ein go-mode yasnippet lsp-ui python-mode company-lsp lsp-mode markdown-mode racer flycheck-rust exec-path-from-shell company-racer rust-mode magit open-junk-file flycheck-elm company use-package atom-one-dark-theme org-plus-contrib))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(provide 'init)
;;; init.el ends here
