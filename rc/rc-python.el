;;; emacs-rc-python.el ---

;; Copyright (C) 2011 Alex Ermolov
;;
;; Author: aaermolov@gmail.com
;; Keywords:
;; Requirements:
;; Status: not intended to be distributed yet

(autoload 'jedi:setup "jedi" nil t)

(let ((python-libs-path
       (cond
        ((eq system-type 'darwin)
         "/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7:")
        ((eq system-type 'gnu/linux)
         "/usr/lib64/python2.7:"))))
  (setenv "PYTHONPATH"
        (concat
         python-libs-path
         (mapconcat 'identity private/python-path-job-projects "")
         (getenv "PYTHONPATH"))))

(setq jedi:setup-keys t)
(setq jedi:complete-on-dot t)


(defun custom/insert-debugger-statements ()
  "inserts debugger statements at point."
  (interactive)
  (push-mark)
  (save-excursion
    (insert "import ipdb\nipdb.set_trace()\n")
    (beginning-of-line)
    (python-indent-region (mark) (point)))
  (pop-mark))


;#############################################################################
;#   Hooks
;############################################################################
(defun custom/python-mode-hook ()
  (auto-fill-mode 1)
  (setq indent-tabs-mode nil)
  (setq tab-width 4)
  (define-key python-mode-map (kbd "C-c l") 'pylint)
  (define-key python-mode-map (kbd "C-c p e") 'pep8)
  (define-key python-mode-map (kbd "C-c h") 'pylookup-lookup-at-point)
  (define-key python-mode-map (kbd "C-c [") 'python-nav-beginning-of-block)
  (define-key python-mode-map (kbd "C-c 9") 'python-nav-beginning-of-statement)
  (define-key python-mode-map (kbd "C-c <up>") 'python-nav-backward-up-list)
  (define-key python-mode-map (kbd "C-c ,") 'python-nav-backward-block)
  (define-key python-mode-map (kbd "C-c <left>") 'python-nav-backward-statement)
  (define-key python-mode-map (kbd "C-c <right>") 'python-nav-forward-statement)
  (define-key python-mode-map (kbd "C-c .") 'python-nav-forward-block)
  (define-key python-mode-map (kbd "C-c <down>") 'python-nav-end-of-defun)
  (define-key python-mode-map (kbd "C-c 0") 'python-nav-end-of-statement)
  (define-key python-mode-map (kbd "C-c ]") 'python-nav-end-of-block)
  (define-key python-mode-map (kbd "C-M-f") 'python-nav-forward-sexp)
  (define-key python-mode-map (kbd "C-c 6") 'custom/insert-debugger-statements)
  (setq flycheck-checker 'python-flake8))

(add-hook 'python-mode-hook 'custom/python-mode-hook)
(add-hook 'python-mode-hook 'common-hooks/comment-hook)
(add-hook 'python-mode-hook 'common-hooks/prog-helpers)
(add-hook 'python-mode-hook 'common-hooks/newline-hook)
(add-hook 'python-mode-hook
  (lambda ()
    (setq imenu-create-index-function 'imenu-default-create-index-function)))
(add-hook 'python-mode-hook 'yas/minor-mode-on)
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook 'jedi:ac-setup)

(setq mumamo-background-colors nil)

(setq flake8-multi/exclude-patterns '("env" "site-packages" "old"))

(global-set-key (kbd "C-c f") 'flake8-multi)

(setenv "PYLINTRC"
        (concat
         config-basedir
         "contrib/.pylintrc"))

;; pylookup
;; add pylookup to your loadpath, ex) ~/.emacs.d/pylookup
(setq pylookup-dir "/home/octocat/.emacs.d/el-get/pylookup") ;; TODO use constants

;; load pylookup when compile time
(eval-when-compile (require 'pylookup))

;; set executable file and db file
(setq pylookup-program (concat pylookup-dir "/pylookup.py"))
(setq pylookup-db-file (concat pylookup-dir "/pylookup.db"))

;; set search option if you want
(setq pylookup-search-options '("--insensitive" "0" "--desc" "0"))

;; to speedup, just load it on demand
(autoload 'pylookup-lookup "pylookup"
  "Lookup SEARCH-TERM in the Python HTML indexes." t)

(autoload 'pylookup-update "pylookup"
  "Run pylookup-update and create the database at `pylookup-db-file'." t)

(defadvice pylookup-lookup
  (around change-browse-url-browser-function activate)
  "Use w3m for slime documentation lookup."
  (let ((browse-url-browser-function 'w3m-browse-url))
    ad-do-it))

(provide 'rc-python)

;;; emacs-rc-python.el ends here
