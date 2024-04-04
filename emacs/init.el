

;; Set the garbage collector to run less
;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))


;; Load config files
(load "~/.emacs.d/sd/packages.el")
(load "~/.emacs.d/sd/evil.el")
(load "~/.emacs.d/sd/options.el")
(load "~/.emacs.d/sd/org.el")


;; Set font
(set-face-attribute 'default nil :font "Berkeley Mono" :height 156)

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                   (time-subtract after-init-time before-init-time)))
           gcs-done))

(pcase system-type
  ('gnu/linux "It's Linux!")
  ('windows-nt "It's Windows!")
  ('darwin "It's macOS!"))


(if (daemonp)
    (message "Loading in the daemon!")
    (message "Loading in regular Emacs!"))

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))
(add-hook 'emacs-startup-hook #'efs/display-startup-time)


