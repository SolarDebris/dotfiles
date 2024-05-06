;; ----------
;; Packages |
;; ----------

;;(set-variable package-check-package-signatures nil)

;;; Code:
;; Setup package archives
(defun sd/setup-pkg-archives ()
  "Setup package archives."
  (require 'package)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/")))

;; Function that refreshes packages
(defun sd/pkg-refresh ()
  "Initialize packages and refresh contents."
  (unless package--initialized
    (package-initialize))

  (package-refresh-contents)
  (unless (package-installed-p 'use-package)
    (package-install 'use-package)
    (require 'use-package))
  (package-refresh-contents))

;; Hook org mode
(defun sd/org-mode-setup ()
  "Setup org mode."
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (setq org-habit-graph-column 60)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


(straight-use-package 'use-package)



(sd/setup-pkg-archives)
(sd/pkg-refresh)

;;-----------------
;; INSTALL THEMES |
;;-----------------
(use-package doom-themes
  :straight t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-dracula t)

  (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  (setq doom-themes-treemacs-theme "doom-atom")
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

(use-package compat
  :straight t)

(use-package doom-modeline
  :straight t
  :hook (after-init . doom-modeline-mode))

;; Download Evil
(use-package evil
  :straight t)

;;--------------------
;; Org Mode Packages |
;;--------------------

(use-package org
  :straight t
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
(use-package org-present
  :straight t)

(use-package org-modern
  :straight t)

(with-eval-after-load 'org (global-org-modern-mode))


(use-package org-brain
  :straight t
  :init
  (setq org-brain-path "~/brain")
  ;; For Evil users
  (with-eval-after-load 'evil
    (evil-set-initial-state 'org-brain-visualize-mode 'emacs))
  :config
  (bind-key "C-c b" 'org-brain-prefix-map org-mode-map)
  (setq org-id-track-globally t)
  (setq org-id-locations-file "~/.emacs.d/.org-id-locations")
  (add-hook 'before-save-hook #'org-brain-straight-ids-in-buffer)
  (push '("b" "Brain" plain (function org-brain-goto-end)
          "* %i%?" :empty-lines 1)
        org-capture-templates)
  (setq org-brain-visualize-default-choices 'all)
  (setq org-brain-title-max-length 12)
  (setq org-brain-include-file-entries nil
        org-brain-file-entries-use-title nil))

;; Allows you to edit entries directly from org-brain-visualize
(use-package polymode
  :straight t
  :config
  (add-hook 'org-brain-visualize-mode-hook #'org-brain-polymode))

;; Install Magit
(use-package magit
  :straight t
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))


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

(use-package corfu
  ;; Optional customizations
  :straight t
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  :init
  (global-corfu-mode)
  :straight t)

(use-package flycheck
  :straight t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package cc-mode
  :hook (("\\.cpp\\'" "\\.c\\'") . cc-mode))

(use-package ccls
  :straight t
  :after projectile
  :ensure-system-package ccls
  :custom
  (ccls-args nil)
  (ccls-executable (executable-find "ccls"))
  (projectile-project-root-files-top-down-recurring
   (append '("compile_commands.json" ".ccls")
           projectile-project-root-files-top-down-recurring))
  :config (push ".ccls-cache" projectile-globally-ignored-directories))

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

(use-package deadgrep
  :straight t
  :bind ("C-c C-f" . deadgrep))

(use-package beacon
  :straight t)

(require 'beacon)
(beacon-mode 1)

(use-package hydra
  :straight t)


(use-package fzf
  :straight t
  ;;:bind ("C-z f z" . fzf)
  :config
  (setq fzf/args "-x --color bw --print-query --margin=1,0 --no-hscroll"
        fzf/executable "fzf"
        fzf/git-grep-args "-i --line-number %s"
        ;; command used for `fzf-grep-*` functions
        ;; example usage for ripgrep:
        fzf/grep-command "rg --no-heading -nH"
        ;;fzf/grep-command "grep -nrH"
        ;; If nil, the fzf buffer will appear at the top of the window
        fzf/position-bottom t
        fzf/window-height 15))

(use-package which-key
  :straight t
  :defer 0.2
  :diminish
  :config (which-key-mode))

(use-package vterm
    :straight t)

(use-package dashboard
  :straight t
  :config
  (dashboard-setup-startup-hook))

(use-package all-the-icons
  :straight t)

(use-package treemacs
  :straight t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                2000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-project-follow-into-home        nil
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)
    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :straight t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :straight t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :straight t)

(use-package treemacs-magit
  :after (treemacs magit)
  :straight t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :straight t
  :config (treemacs-set-scope-type 'Perspectives))

(use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
  :after (treemacs)
  :straight t
  :config (treemacs-set-scope-type 'Tabs))
