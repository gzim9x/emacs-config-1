;; -*- coding: utf-8 -*-
;;
;; Filename: rc-completion.el
;; Created:  Sun May 4 23:57:55 2014 +0400
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package auto-complete
  :commands auto-complete
  :init
  (progn
    (use-package auto-complete-config)
    (use-package auto-complete-extension)
    (use-package auto-complete-emacs-lisp)
    (use-package auto-complete-latex)
    (use-package auto-complete-yasnippet)
    (use-package ac-slime)
    (use-package ac-helm))
  :config
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)
    (diminish 'auto-complete-mode " α")
    (setq ac-auto-start nil)
    (setq ac-quick-help-delay 0.5)
    (add-to-list 'ac-modes 'slime-repl-mode)
    (add-hook 'slime-mode-hook 'set-up-slime-ac)
    (add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
    (add-hook 'auto-complete-mode-hook 'ac-common-setup)
    (define-key ac-complete-mode-map [next] 'ac-page-next)
    (define-key ac-complete-mode-map [prior] 'ac-page-previous)
    (define-key ac-complete-mode-map (kbd "C-s") 'ac-isearch)
    (global-set-key (kbd "C-<tab>") 'ac-complete-with-helm)
    ))

(use-package yasnippet
  :init
  (use-package helm-c-yasnippet)
  :config
  (progn
    ;; unset both to remove ALL translations
    (define-key yas-minor-mode-map [(tab)] nil) ;FIXME: try using unbind-key
    (define-key yas-minor-mode-map (kbd "TAB") nil)
    (bind-key "C-M-<return>" 'helm-yas-complete)
    (setq yas/next-field-key '("<backtab>" "<S-tab>"))
    (setq yas/prev-field-key '("<C-tab>"))
    (setq yas-snippet-dirs nil)
    (setq helm-yas-space-match-any-greedy t)
    (push custom/yasnippet-dir yas-snippet-dirs)
    (push custom/yasnippet-private-dir yas-snippet-dirs)
    (yas--initialize)
    (setq yas-prompt-functions
          '(yas-completing-prompt
            yas-x-prompt
            yas-no-prompt))
    ;; Wrap around region
    (setq yas/wrap-around-region t)
    (add-hook 'after-save-hook 'update-yasnippets-on-save)
    ;; Jump to end of snippet definition
    (define-key yas/keymap (kbd "<return>") 'yas/exit-all-snippets) ;FIXME: try using bind-key
    (define-key yas/keymap (kbd "C-e") 'yas/goto-end-of-active-field)
    (define-key yas/keymap (kbd "C-a") 'yas/goto-start-of-active-field)
    (global-set-key (kbd "C-c C-y C-v") 'yas-visit-snippet-file)
    (global-set-key (kbd "C-c C-y C-n") 'yas-insert-snippet)
    ))

(global-set-key (kbd "C-S-<iso-lefttab>") 'hippie-expand)

(provide 'rc-completion)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; rc-completion.el ends here
