;;; init.el --- Initialization file for Emacs.
;;; Commentary:
;; Emacs Startup File --- initialization for Emacs

;;; Code:
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;If this is nil, split-window-sensibly is not allowed to split a window vertically.
(setq split-height-threshold nil)

(defun shell1 () "Switch to or create *shell-1."
       (interactive) (shell "*shell-1*"))
(defun shell2 () "Switch to or create *shell-2."
       (interactive) (shell "*shell-2*"))
(defun shell3 () "Switch to or create *shell-3."
       (interactive) (shell "*shell-3*"))

(global-set-key (kbd "C-1") 'shell1)
(global-set-key (kbd "C-2") 'shell2)
(global-set-key (kbd "C-3") 'shell3)
(global-set-key (kbd "C-c 1") 'shell1)
(global-set-key (kbd "C-c 2") 'shell2)
(global-set-key (kbd "C-c 3") 'shell3)

;; use-package
(eval-when-compile
  (require 'use-package))

;; use-package configurations
(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(use-package company :ensure t)

(use-package spaceline
  :ensure t
  :config
  (setq powerline-default-separator 'contour)
  (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
  (spaceline-spacemacs-theme))

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (defalias #'forward-evil-WORD #'forward-evil-symbol))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

(use-package magit
  :after (evil)
  :ensure t
  :bind ("C-x g" . magit-status)
  :config
  (global-magit-file-mode))

(use-package evil-magit
  :after (evil magit)
  :ensure t)

(use-package evil-surround
  :ensure t
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-snipe
  :ensure t
  :after evil
  :hook
  (magit-mode . turn-off-evil-snipe-override-mode)
  :config
  (evil-define-key '(visual normal motion operator) evil-snipe-local-mode-map
    "s" 'nil
    "S" 'nil
    "f" 'nil
    "F" 'nil
    "t" 'nil
    "T" 'nil
    "f" 'evil-snipe-s
    "F" 'evil-snipe-S
    "t" 'evil-snipe-x
    "T" 'evil-snipe-X)
  (evil-snipe-mode 1)
  (evil-snipe-override-mode 1))

(use-package projectile
  :ensure t
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (projectile-mode)
  (projectile-tags-exclude-patterns)
  (setq projectile-switch-project-action 'shell1))

(use-package ace-window
  :ensure t
  :bind ("M-o" . ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  ;; (setq aw-background nil)
  )

(use-package flycheck
  :ensure t
  :hook
  (ruby-mode . (lambda ()
                 (setq-local flycheck-command-wrapper-function
                             (lambda (command)
                               (append '("bundle" "exec") command)))))
  :config
  (global-flycheck-mode))

(use-package restclient
  :ensure t
  :config
  (setq restclient-inhibit-cookies t))

(use-package web-mode
  :ensure t
  :mode "\\.erb\\'"
  :config (setq web-mode-markup-indent-offset 2))

(use-package ivy
  :ensure t
  :bind
  (("C-c r" . ivy-resume)
   ("C-c s" . counsel-rg)
   ("C-s"   . swiper))
  :config
  (ivy-mode 1)
  (setq ivy-height 20)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-re-builders-alist
	'((swiper . ivy--regex-plus)
	  (counsel-ag . ivy--regex-plus)
	  (counsel-rg . ivy--regex-plus)
	  (t . ivy--regex-fuzzy)))
  (setq projectile-completion-system 'ivy)
  (setq magit-completing-read-function 'ivy-completing-read)
  (setq counsel-rg-base-command "rg -S -M 512 --no-heading --line-number --color never %s .")
  (setq counsel-ag-base-command "ag -W 256 --nocolor --nogroup %s"))


(use-package counsel
  :ensure t
  :after ivy
  :config
  (counsel-mode))

(use-package elixir-mode
  :ensure t
  :hook
  (elixir-mode . (lambda ()
                   (setq column-enforce-column 80)
                   (column-enforce-mode))))

(use-package flyspell
  :ensure t
  :hook
  (text-mode . flyspell-mode)
  (html-mode . (lambda() (flyspell-mode -1))))

(use-package ensime
  :ensure t
  :pin melpa-stable
  :hook (java-mode . (lambda()
		       (setq ensime-startup-notification nil)
		       (ensime))))

(use-package evil-org
  :ensure t
  :after evil
  :hook (org-mode . evil-org-mode))

(use-package flx-ido :ensure t)
  ;; (ido-mode 1)
  ;; (flx-ido-mode 1)
  ;; (setq ido-everywhere t)
  ;; (setq ido-enable-flex-matching t)
  ;; (setq ido-use-faces nil)
  ;; (setq ido-use-filename-at-point 'guess)
  ;; (setq ido-use-url-at-point t))

(use-package string-inflection :ensure t)

(use-package ag
  :ensure t
  :hook (ag-mode . wgrep-ag-setup)
  :config
  (setq ag-highlight-search t)
  (setq ag-arguments (cons "-W 256" ag-arguments)))

(use-package wgrep :ensure t)
(use-package wgrep-ag
  :ensure t
  :after wgrep)

(use-package json-mode
  :ensure t
  :hook (json-mode . (lambda()(setq js-indent-level 2))))

(use-package rjsx-mode
  :after (js2-mode js-mode)
  :ensure t)
(setq js-indent-level 2)
(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))

(use-package rubocop :ensure t)

(use-package column-enforce-mode
  :ensure t
  :hook (prog-mode . column-enforce-mode)
  :config
  (setq column-enforce-mode-column 80))

(use-package ws-butler
  :ensure t
  :config
  (ws-butler-global-mode))

(use-package org-present
  :ensure t
  :after evil
  :hook
  ((org-present-mode . (lambda ()
			      (evil-mode 0)
			      (hide-mode-line-mode 1)
			      (org-present-big)
			      (org-display-inline-images)
			      (org-present-hide-cursor)
			      (org-present-read-only)))
  (org-present-mode-quit . (lambda ()
			     (evil-mode 1)
			     (hide-mode-line-mode 0)
			     (org-present-small)
			     (org-remove-inline-images)
			     (org-present-show-cursor)
			     (org-present-read-write)))))

(use-package yaml-mode :ensure t)

(use-package zenburn-theme
  :ensure t
  :config (load-theme 'zenburn t))


(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package gnutls
  :ensure t
  :config
  (add-to-list 'gnutls-trustfiles "/usr/local/etc/openssl/cert.pem"))

(use-package yari :ensure t)

(use-package midnight)

(use-package markdown-mode
  :ensure t
  :hook
  (markdown-mode . auto-fill-mode)
  (markdown-mode . display-line-numbers-mode)
  (markdown-mode . (lambda() (setq-local fill-column 80)))
  (markdown-mode . company-mode))

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'company-mode)
(add-hook 'ruby-mode-hook 'rubocop-mode)

(modify-syntax-entry ?_ "w")
(modify-syntax-entry ?- "w")

(defalias 'yes-or-no-p 'y-or-n-p)
(setenv "PAGER" "cat")

;; look and feel
(scroll-bar-mode -1)
(setq column-number-mode t)
(show-paren-mode 1)
(add-hook 'after-init-hook 'toggle-frame-fullscreen)
(setq show-trailing-whitespace t)
(menu-bar-mode -1)
(setq use-dialog-box nil)

;; tags
(setq tags-add-tables nil)

;; ediff
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; ispell
(setq ispell-program-name "/usr/local/bin/ispell")

;; recentf
(recentf-mode 1)

;; shell
(setq shell-file-name "/bin/bash")
(add-hook 'comint-mode-hook (lambda () (setq comint-process-echoes t)))

;; text formatting
(electric-indent-mode 1)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

;; backups
(setq backup-directory-alist
      `((".*" . ,"~/.emacs.backups/")))
(setq auto-save-file-name-transforms
      `((".*" ,"~/.emacs.saves/" t)))

(setq-default display-buffer-alist
              '(("*shell-?*" (display-buffer-reuse-window
                              display-buffer-same-window))))

;; babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((shell . t)))

(setq inhibit-startup-screen t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(custom-safe-themes
   (quote
    ("54f2d1fcc9bcadedd50398697618f7c34aceb9966a6cbaa99829eb64c0c1f3ca" "e11569fd7e31321a33358ee4b232c2d3cf05caccd90f896e1df6cab228191109" default)))
 '(default-input-method "latin-prefix")
 '(fci-rule-color "#383838")
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(package-selected-packages
   (quote
    (web-mode yari ctags-update spaceline wget evil-collection wgrep-ag use-package string-inflection json-mode evil-surround rg counsel-projectile evil-magit rjsx-mode js2-mode hide-mode-line org-present yaml-mode evil-org ivy-hydra hydra counsel ivy rubocop haskell-mode ws-butler markdown-mode alchemist ag ace-window zenburn-theme evil-snipe column-enforce-mode flx-ido company yasnippet yasnippet-snippets meghanada projectile flycheck exec-path-from-shell restclient erlang evil)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(safe-local-variable-values (quote ((column-enforce-column . 120))))
 '(tool-bar-mode nil)
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit default :stipple nil :background "#3F3F3F" :foreground "#DCDCCC" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 140 :width normal :foundry "nil" :family "Menlo")))))
