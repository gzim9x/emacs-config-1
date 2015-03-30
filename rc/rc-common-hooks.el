;; -*- coding: utf-8 -*-
;;
;; Filename: rc-common-hooks.el
;; Created:  Fri May 24 22:41:54 2013 +0400
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
        js-mode
        js2-mode
        html-mode
        lua-mode
        org-mode
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

(defun common-hooks/newline-hook ()
  (local-set-key (kbd "C-m") 'newline-and-indent)
  (local-set-key (kbd "<return>") 'newline-and-indent))

;; show FIXME/TODO/BUG keywords
(defun common-hooks/prog-helpers ()
  ;; highlight additional keywords
  (font-lock-add-keywords nil '(("\\<\\(FIXME\\|FIX_ME\\|FIX ME\\):" 1 font-lock-warning-face t)))
  (font-lock-add-keywords nil '(("\\<\\(BUG\\|BUGS\\):" 1 font-lock-warning-face t)))
  (font-lock-add-keywords nil '(("\\<\\(TODO\\|TO DO\\NOTE\\|TBD\\):" 1 font-lock-warning-face t)))
  (font-lock-add-keywords nil '(("\\<\\(DONE\\|HACK\\):" 1 font-lock-doc-face t)))
  ;; highlight too long lines
  (font-lock-add-keywords nil '(("^[^\n]\\{120\\}\\(.*\\)$" 1 font-lock-warning-face t)))
  )

(defun common-hooks/trailing-whitespace-hook ()
  (when (member major-mode custom/trailing-whitespace-modes)
    (delete-trailing-whitespace)))

(defun common-hooks/untabify-hook ()
  (when (member major-mode custom/untabify-modes)
    (untabify (point-min) (point-max))))

(add-hook 'before-save-hook 'common-hooks/trailing-whitespace-hook)
(add-hook 'before-save-hook 'common-hooks/untabify-hook)

(provide 'rc-common-hooks)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; rc-common-hooks.el ends here
