;; Install MELPA Packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
;;(package-initialize)
(package-install 'use-package)
(require 'use-package)
(package-refresh-contents)

;;
;; Install Doom Themes 
;;

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t    
        doom-themes-enable-italic t) 
  (load-theme 'doom-dracula t)

  (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  (setq doom-themes-treemacs-theme "doom-atom") 
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

;; Download Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))

;;
;; Org Packages
;;

;; Install and hook org mode
(defun sd/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(use-package org
  :hook (org-mode . sd/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(require 'org-habit)
(add-to-list 'org-modules 'org-habit)
(setq org-habit-graph-column 60)

;; Install org-present if needed
(unless (package-installed-p 'org-present)
  (package-install 'org-present))


;; Install Magit
(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package evil-magit
  :after magit)


;;
;; LSP Packages
;;

;; Install Lsp Mode
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t)
  :hook
  ((c-mode c++-mode python-mode asm-lsp go-mode rust-mode) . lsp)
  )


;; Install company completion
(use-package company
  :after lsp-mode
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package go-mode
  :mode ("\\.go\\'" . go-mode))

(use-package rust-mode
  :mode ("\\.rs\\'" . rust-mode)
  :hook (rust-mode . eglot-ensure))

(use-package zig-mode
  :mode ("\\.zig\\'" . zig-mode)
  :hook (zig-mode . eglot-ensure)
  :custom
  (zig-format-on-save nil)
  (zig-format-show-buffer nil))

(use-package lua-mode
  :mode ("\\.lua\\'" . lua-mode))

(use-package json-mode
  :mode ("\\.json\\'" . json-mode))

(use-package yaml-mode
  :mode ("\\.yml\\'" . yaml-mode))

(use-package deadgrep
  :bind ("C-c C-f" . deadgrep))
