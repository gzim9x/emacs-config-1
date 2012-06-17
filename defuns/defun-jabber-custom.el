;;; defun-jabber-custom.el ---

;; Copyright (C) 2011 Alex Ermolov
;;
;; Author: aaermolov@gmail.com
;; Keywords:
;; Requirements:
;; Status: not intended to be distributed yet

(defun jabber-libnotify-message(from msg)
  "Show MSG using libnotify"
  (let ((process-connection-type nil))
    (start-process "notification" nil "notify-send"
                   "-t" jabber-libnotify-timeout
                   "-i" jabber-libnotify-icon
                   from msg)))

(defun jabber-libnotify-message-display(from buffer text propsed-alert)
  (jabber-libnotify-message from text))

(defun x-urgency-hint (frame arg &optional source)
  (let* ((wm-hints (append (x-window-property
                            "WM_HINTS" frame "WM_HINTS"
                            (if source
                                source
                              (string-to-number
                               (frame-parameter frame 'outer-window-id)))
                            nil t) nil))
         (flags (car wm-hints)))
    (setcar wm-hints
            (if arg
                (logior flags #x00000100)
              (logand flags #xFFFFFEFF)))
    (x-change-window-property "WM_HINTS" wm-hints frame "WM_HINTS" 32 t)))

;#############################################################################
;#   Jabber chat shortcuts
;############################################################################
(defun custom-jabber/insert-inlove-smile ()
  "Insert *IN LOVE* at cursor point."
  (interactive)
  (insert "*IN LOVE* ")
  (backward-char 10))

(defun custom-jabber/insert-kiss-smile ()
  "Insert :-* at cursor point."
  (interactive)
  (insert ":-* ")
  (backward-char 4))

(defun custom-jabber/wrap-replace-regexp ()
  "Wraps current word in ed's 'replace' regexp"
  (interactive)
  (kill-ring-save (region-beginning) (region-end))
  (end-of-buffer)
  (yank)
  (beginning-of-line)
  (insert "s/")
  (end-of-line)
  (insert "//")
  (backward-char 1))

(defun custom-jabber/wrap-misreading ()
  "Wraps current word in ed's 'replace' regexp"
  (interactive)
  (kill-ring-save (region-beginning) (region-end))
  (end-of-buffer)
  (yank)
  (beginning-of-line)
  (insert "+ прочтение: \"")
  (end-of-line)
  (insert "\" -> \"\"")
  (backward-char 1))

(defun custom/find-url-backward ()
  (interactive)
  (re-search-backward "\\(http\\(s\\)*://\\)\\(www.\\)*\\|\\(www.\\)" nil t))

(defun custom/find-url-forward ()
  (interactive)
  (re-search-forward "\\(http\\(s\\)*://\\)\\(www.\\)*\\|\\(www.\\)" nil t))


;#############################################################################
;#   Jabber smileys
;############################################################################
(require 'xml)

(defun smiley-parse-node (node)
  "Extracts smiley data of type (REGEXP 1 FILENAME) from a node."
  (when (listp node)
    (let* ((filename
            (cdr (assq 'file (xml-node-attributes node))))
           (smilies
            (mapcar
             (lambda (data) (car (last data)))
             (xml-get-children node 'string))))
                        (list
        (concat (regexp-opt smilies "\\(") "\\W")
        1 filename)
       )))

(defun smiley-parse-file (filename)
  "Returns smiley data list for smiley-regexp-alist."
  (let ((root (xml-parse-file filename)))
    (mapcar 'smiley-parse-node
            (xml-get-children
             (car root) ;; we skip <messaging-emoticon-map>
             'emoticon))
    ))

(defvar smiley-base-directory nil
  "Directory containing smiley packs (folders).")

(defun smiley-load-theme (pack)
  "Loads smiley theme PACK into smiley.el.
  Each theme should be a folder inside smiley-data-directory. For example
  smiley-data-directory is set to '/home/bobry/.emacs.d/smileys, so possible
  directory structure could be:
  .
  |-- default
  |-- kolobok
  `-- tango

  default, kolobok and tango are valid PACK values."
  (interactive "sTheme: ")
  (when smiley-base-directory
    (let* ((smiley-dir (format "%s/%s/" smiley-base-directory pack ))
                                         (smiley-path (concat smiley-dir "emoticons.xml")))
      (when (file-exists-p smiley-path)
        (setq
         smiley-style 'low-color ;; this is done for compatibility reasons
         smiley-data-directory smiley-dir
         smiley-regexp-alist (smiley-parse-file smiley-path))
        (smiley-update-cache))
      )))

;;; defun-jabber-custom.el ends here
