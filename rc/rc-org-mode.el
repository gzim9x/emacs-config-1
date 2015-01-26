;;; emacs-rc-org-mode.el ---

;; Copyright (C) 2011 Alex Ermolov
;;
;; Author: aaermolov@gmail.com
;; Keywords:
;; Requirements:
;; Status: not intended to be distributed yet

;#############################################################################
;#   Load extensions
;############################################################################
(autoload 'icalendar-import-buffer "icalendar" "Import iCalendar data from current buffer" t)

(require 'org-install)
(require 'org)
(require 'org-agenda)
(require 'org-pomodoro)
(require 'org-protocol)
(require 'ox-html)
(require 'org-archive)
(require 'org-attach)

;#############################################################################
;#   Customizations
;############################################################################
(add-to-list 'file-coding-system-alist (cons "\\.\\(org\\|org_archive\\|/TODO\\)$"  'utf-8))

(setq org-agenda-files (append (all-files-under-dir-recursively (at-org-dir) "org")))
;TODO: maybe do it less straightforward
(add-to-list 'org-agenda-files (at-config-basedir "todo.org"))
(add-to-list 'org-agenda-files (at-config-basedir "totry.org"))
(add-to-list 'org-agenda-files "/home/octocat/.stumpwm.d/todo.org")

; Targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets (quote ((org-agenda-files :maxlevel . 5) (nil :maxlevel . 5))))
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-completion-use-ido t)
(setq org-indirect-buffer-display 'current-window)
(setq org-agenda-span 'month)
(setq org-deadline-warning-days 14)
(setq org-agenda-show-all-dates t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-todo-list-sublevels nil)
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-include-diary t)
(setq org-agenda-include-all-todo t)
(setq org-reverse-note-order t)
(setq org-fast-tag-selection-single-key (quote expert))
(setq org-startup-folded nil)
(setq org-log-done t)
(setq org-hide-leading-stars t)
(setq org-use-property-inheritance t)
(setq org-special-ctrl-a/e t)
(setq org-special-ctrl-k t)
(setq org-blank-before-new-entry (quote ((heading . auto) (plain-list-item))))
(setq org-agenda-dim-blocked-tasks 'invisible)
(setq org-enforce-todo-checkbox-dependencies t)
(setq org-enforce-todo-dependencies t)
(setq org-default-notes-file custom/org-capture-file)
(setq org-insert-mode-line-in-empty-file t)
(setq org-log-done t) ;; read documentation
(setq org-ditaa-jar-path (at-config-basedir "resources/ditaa0_9.jar"))
(setq org-attach-directory "org-attach-data")
(setq org-refile-target-verify-function 'custom/verify-refile-target)


(setq kw-seq-common '(sequence "TODO(t)" "GOING(g!)" "NEXT(x)" "WAITING(w@/!)" "SOMEDAY(s@)"
                  "|" "DONE(d!/@)" "CANCELLED(c@/!)"))
(setq org-todo-keywords
      `(,kw-seq-common))
(setq org-todo-keywords-for-agenda '("TODO(t)" "WAITING(w)" "GOING(g)" "NEXT(x)"))
(setq org-done-keywords-for-agenda '("DONE(d)" "CANCELLED(c)"))
(setq org-agenda-time-grid
      '((daily today require-timed remove-match)
        "----------------"
        (930 1000 1200 1400 1600 1800 2000 2200 2400 2500)))
(setq org-todo-keyword-faces
      '(("TODO" . (:foreground "red" :weight bold))
        ("WAITING" . (:foreground "orange" :weight bold))
        ("CANCELLED" . (:foreground "cyan" :weight bold))
        ("DONE" . (:foreground "green" :weight bold))))
(setq org-priority-faces
      '((?A :foreground "red" :weight bold)
        (?B :foreground "#94bff3" :weight bold)
        (?C :foreground "#6f6f6f")))
(setq org-tag-alist '(("current" . ?c)
                      ("orgmode" . ?g)
                      ("purchase" . ?p)
                      ("master" . ?m)
                      ("process" . ?r)
                      ("ordering" . ?o)
                      ("home_improvements" . ?h)))
(setq org-agenda-custom-commands
      '(("d" . "some non-straightforward TODO statuses")
        ("dc" todo "SOMEDAY|CANCELLED|CLOSED" nil)
        ("dw" todo "WAITING|LATER" nil)
        ("dg" todo "GOING" nil)
        ("c" . "by context")
        ("ch" tags "+@home")
        ("co" tags "+@work")
        ("cw" tags "+@workplace")
        ("cj" tags "+@journey")
        ("cp" tags "+@phonecall")
        ("cs" tags "+@someday")
        ("e" . "by essence")
        ("ec" tags "+current")
        ("em" tags "+master")
        ("eo" tags "+ordering")
        ("ef" tags "+fix")
        ("ed" tags "+develop")
        ("ei" tags "+investigate")
        ("u" . "unassigned")
        ("uu" alltodo ""
         ((org-agenda-skip-function
           (lambda nil
             (org-agenda-skip-entry-if 'scheduled 'deadline 'regexp "<[^>\n]+>")))
          (org-agenda-overriding-header "Unscheduled TODO entries: ")))
        ("up" alltodo ""
         ((org-agenda-skip-function
           (lambda nil
             (org-agenda-skip-entry-if 'regexp "\\[#[ABC]]")))
          (org-agenda-overriding-header "Unprioritized TODO entries: ")))
        ("P" "Prioritized tasks"
         ((tags-todo "+PRIORITY=\"A\"")
          (tags-todo "+PRIORITY=\"B\"")
          (tags-todo "+PRIORITY=\"C\"")))
        ("p" tags "+purchase")
        ("t" . "tickets")
        ("te" tags "+ticket+emacs")
        ("ts" tags "+ticket+stumpwm")
        ))

(setq org-capture-templates
      '(("d" "todo")
        ("dh" "tasks at home" entry (file (at-org-dir "/tasks.org")) "* TODO [#C] %? %U :@home:")
        ("do" "tasks at work" entry (file (at-org-dir "/tasks.org")) "* TODO [#C] %? %U :@work:")
        ("dw" "workplace tasks" entry (file (at-org-dir "/tasks.org")) "* TODO [#C] %? %U :@workplace:")
        ("dj" "tasks on the way" entry (file (at-org-dir "/tasks.org")) "* TODO [#C] %? %U :@journey:")
        ("dp" "phonecalls" entry (file (at-org-dir "/tasks.org")) "* TODO [#C] %? %U :@phonecall:")
        ("ds" "someday" entry (file (at-org-dir "/tasks.org")) "* %? %U :@someday:")
        ("de" "emacs")
        ("det" "emacs todo" entry (file (at-config-basedir "todo.org")) "* TODO [#C] %? %U :emacs:ticket:")
        ("dey" "emacs try" entry (file (at-config-basedir "totry.org")) "* TODO [#C] %? %U :emacs:try:")
        ("i" "sink")
        ("ip" "project ideas" entry (file (at-org-dir "/sink.org")) "* %? %U :project/idea:")
        ("in" "job notes" entry (file (at-org-dir "/sink.org")) "* %? %U :@work:note:")
        ("ia" "newspaper articles" entry (file (at-org-dir "/sink.org")) "* %? %U :newspaper:toread:")
        ("il" "side links" entry (file (at-org-dir "/sink.org")) "* %? %U :side_link:")
        ("is" "search")
        ("isb" "book" entry (file (at-org-dir "/sink.org")) "* TODO %? %U :search:book:")
        ("isf" "food" entry (file (at-org-dir "/sink.org")) "* TODO %? %U :search:food:")
        ("ist" "token" entry (file (at-org-dir "/sink.org")) "* TODO %? %U :search:token:")
        ("isl" "by link" entry (file (at-org-dir "/sink.org")) "* TODO %? %U :search:link:")
        ("t" "tickets")
        ("tx" "xmonad tickets" entry (file+headline (at-homedir "/.xmonad/todo.org")) "* TODO [#C] %? %U :xmonad:ticket:")
        ("ts" "stumpwm tickets" entry (file (at-homedir "/.stumpwm.d/todo.org")) "* TODO [#C] %? %U :stumpwm:ticket:")
        ("tv" "vim config tickets" entry (file (at-homedir "/workspace/configs/vim-config/todo.org")) "* TODO [#C] %? %U :vim:config:ticket:")
        ("l" "links" entry (file (at-org-dir "/links.org")) "* %? %U :links:send:")
        ("g" "github")
        ("gc" "common" entry (file (at-org-dir "/github.org")) "* %? %U :github:")
        ("gd" "dotfiles" entry (file (at-org-dir "/github.org")) "* %? %U :github:dotfiles:")
        ("ge" "emacs config" entry (file (at-org-dir "/github.org")) "* %? %U :github:emacs-config:")
        ("ga" "awesome config" entry (file (at-org-dir "/github.org")) "* %? %U :github:awesome-config:")
        ("gs" "stumpwm config" entry (file (at-org-dir "/github.org")) "* %? %U :github:stumpwm-config:")
        ("gl" "CL repo to review" entry (file+olp (at-org-dir "/mastering.org") "languages" "Common Lisp" "repos") "* %? %U :github:common_lisp:")
        ("m" "mastering" entry (file+headline (at-org-dir "/mastering.org") "inbox") "* %? %U")
        ("p" "new project" entry (file (at-org-dir "/projects.org")) "* %? %U :project:")
        ("j" "journal (test mode)" entry (file+datetree (at-org-dir "/journal.org")) "* %? %U")
        ))

(setq holiday-orthodox-holidays nil) ; Orthodox holidays to some extent
(setq holiday-personal-holidays nil) ; personal anniversaries, etc.

(setq holiday-other-holidays
      (append holiday-orthodox-holidays holiday-personal-holidays))

(setq calendar-holidays
  (append holiday-other-holidays
          holiday-solar-holidays))


;#############################################################################
;#   Setup
;############################################################################
(appt-activate t)
(run-at-time "00:59" 3600 'org-save-all-org-buffers)
(load (at-config-basedir "last-scrum-timestamp"))

;#############################################################################
;#   Hooks
;############################################################################
(defun custom/org-mode-hook ()
  (local-set-key (kbd "C-x C-a") 'show-all)
  (local-unset-key (kbd "C-c ["))
  (local-unset-key (kbd "C-c ]"))
  (local-unset-key (kbd "C-c C-o"))
  (local-set-key (kbd "C-c C-o C-l") 'open-or-browse-at-point)
  (imenu-add-to-menubar "Imenu"))

(add-hook 'org-mode-hook 'custom/org-mode-hook)
(add-hook 'org-mode-hook 'turn-on-font-lock)
(add-hook 'diary-display-hook 'fancy-diary-display)
(add-hook 'org-after-todo-state-change-hook 'custom/org-todo-changed-hook)
(add-hook 'org-clock-out-hook 'custom/remove-empty-drawer-on-clock-out 'append)
(add-hook 'org-after-refile-insert-hook 'save-buffer)

;#############################################################################
;#   Keybindings
;############################################################################
(global-set-key (kbd "C-c e") 'org-capture)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c b") 'org-iswitchb)
(global-set-key (kbd "C-c t c") 'org-table-create)
(global-set-key (kbd "C-c t s") 'org-sparse-tree)
(global-set-key (kbd "C-c t t") 'org-toggle-timestamp-type)
(global-set-key (kbd "C-c t t") 'org-toggle-timestamp-type)
(global-set-key (kbd "C-c m m") 'org-agenda-bulk-mark-all)
(global-set-key (kbd "C-c m u") 'org-agenda-bulk-unmark-all)
(global-set-key (kbd "<f12>") 'org-pomodoro)

(global-set-key (kbd "C-c C-o C-s") 'save-last-scrum-timestamp)
(global-set-key (kbd "C-c C-o C-m") 'mark-with-finished-timestamp)
(global-set-key (kbd "C-c C-o C-d") 'refile-job-done)

(define-key custom-orgmode-keymap (kbd "g") 'org-clock-goto)
(define-key custom-orgmode-keymap (kbd "p") 'org-set-property)
(define-key custom-orgmode-keymap (kbd "d") 'org-delete-property)
(define-key custom-orgmode-keymap (kbd "s") 'org-schedule)
(define-key custom-orgmode-keymap (kbd "l") 'org-deadline)
(define-key custom-orgmode-keymap (kbd "t") 'org-trello-mode)

(define-key org-mode-map (kbd "C-'") nil)

(provide 'rc-org-mode)

;;; emacs-rc-org-mode.el ends here
