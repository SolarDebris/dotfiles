(load "~/.emacs.d/sd/packages.el")

;;---------------
;; LSP Packages |
;;---------------

;; Install Lsp Mode
(use-package lsp-mode
  :straight t
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t)
  :hook
  ((prog-mode c-mode c++-mode python-mode asm-lsp nasm-mode asm-mode go-mode rust-mode) . lsp)
  )

(use-package lsp-ui
  :straight t)

(use-package lsp-python-ms
  :straight t
  :defer 0.3
  :custom (lsp-python-ms-auto-install-server t))


;; Install company completion
(use-package company
  :after lsp-mode
  :straight t
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(add-hook 'after-init-hook 'global-company-mode)

(use-package company-box
  :straight t
  :after company
  :diminish
  :hook (company-mode . company-box-mode))

;;(use-package corfu
  ;; Optional customizations
  ;;:straight t
  ;;:custom
  ;;(corfu-cycle t)
  ;;(corfu-auto t)
  ;;:init
  ;;(global-corfu-mode)
  ;;:straight t)

(use-package flycheck
  :straight t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package cc-mode
  :hook (("\\.cpp\\'" "\\.c\\'") . cc-mode))

(use-package python-mode
  :mode ("\\.py\\'" . python-mode))

(use-package go-mode
  :mode ("\\.go\\'" . go-mode))

(use-package rust-mode
  :mode ("\\.rs\\'" . rust-mode)
  :hook (rust-mode . eglot-straight))

(use-package zig-mode
  :mode ("\\.zig\\'" . zig-mode)
  :hook (zig-mode . eglot-straight)
  :custom
  (zig-format-on-save nil)
  (zig-format-show-buffer nil))

(use-package lua-mode
  :mode ("\\.lua\\'" . lua-mode))

(use-package json-mode
  :mode ("\\.json\\'" . json-mode))

(use-package yaml-mode
  :mode ("\\.yml\\'" . yaml-mode))
