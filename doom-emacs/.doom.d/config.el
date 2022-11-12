;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "awoo"
      user-mail-address "qtwebengine@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;(setq doom-font (font-spec :family "Fira Code" :size 13 :weight 'regular)
;      doom-variable-pitch-font (font-spec :family "Hack" :size 14))
(setq doom-font (font-spec :family "Jetbrains Mono" :size 13 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Hack" :size 14)) ;; Non-monospace!
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-laserwave)
;(setq doom-theme 'TransSide)


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; enable autosave
(setq auto-save-default t)

;; adjusts max columns from 80 to x
(setq-default fill-column 100)

;; treemacs
(setq treemacs-width 30)

;; twittering-mode
(after! twittering-mode
  (setq twittering-icon-mode t
      twittering-convert-fix-size 48
      twittering-use-icon-storage t))

;; mu4e - msmtp (SMTP forwarder)
; (mu init --my-address=corgiboi9898@gmail.com)

;(after! mu4e
;  (setq sendmail-program "/usr/bin/msmtp"
;      send-mail-function #'smtpmail-send-it
;      message-sendmail-f-is-evil t
;      message-sendmail-extra-arguments '("--read-envelope-from")
;      message-send-mail-function #'message-send-mail-with-sendmail)
;  (set-email-account!
;   "gmail"
;   '((mu4e-sent-folder       . "/[Gmail]/Sent Mail")
;     (mu4e-trash-folder      . "/[Gmail]/Bin")
;     (smtpmail-smtp-user     . "corgiboi9898@gmail.com"))
;   t)
;  (setq mu4e-get-mail-command "mbsync gmail"
;        ;; get emails and index every 5 minutes
;        mu4e-update-interval 300
;        ;; send emails with format=flowed
;        mu4e-compose-format-flowed t
;        ;; no need to run cleanup after indexing for gmail
;        mu4e-index-cleanup nil
;        mu4e-index-lazy-check t
;        ;; more sensible date format
;        mu4e-headers-date-format "%d.%m.%y"))
