;;; emacs-rc-common-hooks.el ---

;; Copyright (C) 2011 Alex Ermolov
;;
;; Author: aaermolov@gmail.com
;; Keywords:
;; Requirements:
;; Status: not intended to be distributed yet

;#############################################################################
;#   Customizations
;############################################################################
;; clean trailing whitespaces automatically
(setq custom/trailing-whitespace-modes
      '(
        c++-mode
        c-mode
        haskell-mode
        emacs-lisp-mode
        lisp-mode
        scheme-mode
        erlang-mode
        python-mode
))

;; untabify some modes
(setq custom/untabify-modes
      '(
        haskell-mode
        emacs-lisp-mode
        lisp-mode
        scheme-mode
        erlang-mode
        clojure-mode
        python-mode
))


;#############################################################################
;#   Hooks
;############################################################################
;; common settings for different text & programming modes
(defun common-hooks/comment-hook ()
  (local-set-key (kbd "C-{") 'uncomment-region)
  (local-set-key (kbd "C-}") 'comment-region)
  (local-set-key (kbd "M-]") 'custom/comment-or-uncomment-region)
  )

(defun common-hooks/newline-hook ()
  (local-set-key (kbd "C-m") 'newline-and-indent)
  (local-set-key (kbd "<return>") 'newline-and-indent)
  )

;; show FIXME/TODO/BUG keywords
(defun common-hooks/show-prog-keywords ()
  ;; highlight additional keywords
  (font-lock-add-keywords nil '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))
  (font-lock-add-keywords nil '(("\\<\\(DONE\\):" 1 font-lock-doc-face t)))
  ;; highlight too long lines
  (font-lock-add-keywords nil '(("^[^\n]\\{120\\}\\(.*\\)$" 1 font-lock-warning-face t))))

(defun common-hooks/trailing-whitespace-hook ()
  (when (member major-mode custom/trailing-whitespace-modes)
    (delete-trailing-whitespace)))

(defun common-hooks/untabify-hook ()
  (when (member major-mode custom/untabify-modes)
    (untabify (point-min) (point-max))))

(add-hook 'before-save-hook 'common-hooks/trailing-whitespace-hook)
(add-hook 'before-save-hook 'common-hooks/untabify-hook)

(provide 'rc-common-hooks)

;;; emacs-rc-common-hooks.el ends here
