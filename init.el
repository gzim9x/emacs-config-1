(setq config-basedir (file-name-directory
                      (or (buffer-file-name) load-file-name)))

(load (concat config-basedir "base.el"))

;; (setq debug-on-error t)
;; (setq stack-trace-on-error t)

(setq shell-file-name "/bin/bash")

(setq message-log-max t)

(setq home-directory (getenv "HOME"))
(setq global-username user-login-name)

(setq custom-file (concat config-basedir "customizations.el"))

(add-to-list 'load-path (concat config-basedir "rc"))
(add-to-list 'load-path (concat config-basedir "bundles"))
(add-to-list 'load-path config-basedir)

;; For a new non-file buffer set its major mode based on the buffer name.
;; http://thread.gmane.org/gmane.emacs.devel/115520/focus=115794
;; (setq-default major-mode (lambda ()
;;                            (if buffer-file-name
;;                                (fundamental-mode)
;;                              (let ((buffer-file-name (buffer-name)))
;;                                (set-auto-mode)))))

(mapcar 'load
        (mapcar
         (lambda (path) (concat config-basedir path))
         '("rc-el-get.el"
           "constants.el"
           "credentials.el.gpg"
           )))

(mapcar 'load
  (all-files-under-dir-recursively
   (concat config-basedir "customdefs")))

(load (concat config-basedir "systemtraits.el"))

(require 'bundle-main)

(mapcar 'load
        (mapcar
         (lambda (path) (concat config-basedir path))
         '("rc-auto-modes.el"
           "rc-desktop.el"
           )))
