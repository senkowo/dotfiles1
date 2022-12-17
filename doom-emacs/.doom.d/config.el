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
;;(after! twittering-mode
;;  (setq twittering-icon-mode t
;;      twittering-convert-fix-size 48
;;      twittering-use-icon-storage t))

;; auto-tangle
(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode))

;; move window focus
(map! "C-M h" #'windmove-left
      "C-M l" #'windmove-right
      "C-M k" #'windmove-up
      "C-M j" #'windmove-down
      "C-M o" #'other-window)

;; org-agenda
(after! org
  (setq org-agenda-files '("~/Documents/org/agenda/")))

;; erc
;;(map! :map 'global "SPC d e" #'erc-tls)
(after! erc
  (setq erc-prompt (lambda () (concat "[" (buffer-name) "]"))
        erc-server "irc.libera.chat"
      ;;erc-autojoin-channels-alist '(("irc.libera.chat" "#emacs" "#linux"))
      ;;erc-nick "senko"
      ;;erc-user-full-name ""
      ;; By default, ERC selects the channel buffers when it reconnects. If you'd like it to connect to channels in the background, use this:
      ;;erc-auto-query 'bury
      ;;erc-fill-column 100
      erc-fill-function 'erc-fill-static ; align
      ;;erc-fill-static-center 20          ; align
      ))

;; dired


;; user keybinds
(map! :leader
      (:prefix ("k" . "user-keybinds")
       :desc "clipboard-yank" "p" #'clipboard-yank
       (:prefix ("o" . "open")
        :desc "erc-tls" "e" #'erc-tls))
)

;; startup
;; fix workspaces start in main with emacsclient? (doesn't work...)
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))
;; fix to show bar with emacsclient (should be fixed in the next update of centaur-tabs)
(after! centaur-tabs
  (setq centaur-tabs-set-bar 'right))
