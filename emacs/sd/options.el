;;
;; File for setting options
;;

;; Disable startup message
(setq inhibit-startup-message t)

;; Remove default gnu emacs ui
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)


;; Displays line numbers
(column-number-mode)
(global-display-line-numbers-mode t)
