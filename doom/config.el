;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")
;;
;;
;;
;;
;; Set initial window/frame size
;; ORg stuff
;;
;;
(after! evil
  (evil-ex-define-cmd "W" "w"))
(use-package! gleam-ts-mode
  :mode (rx ".gleam" eos))
(after! lsp-mode
  ;; register the Gleam LSP server
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection (lambda () (list "gleam" "lsp")))
    :activation-fn (lsp-activate-on "gleam")
    :priority -1
    :server-id 'gleam-lsp)))
(after! gleam-ts-mode
  (add-hook 'gleam-ts-mode-hook #'lsp!))
(after! treesit
  (add-to-list 'auto-mode-alist '("\\.gleam$" . gleam-ts-mode)))

(after! gleam-ts-mode
  (unless (treesit-language-available-p 'gleam)
    (gleam-ts-install-grammar)))
(after! org
  (setq org-capture-templates
        '(("t" "Todo"   entry
           (file+headline "~/org/todo.org" "Tasks")
          "* TODO %^{Task Title}  \nSCHEDULED: %^t\n:PROPERTIES:\n:Created: %U\n:END:\n\n** Notes\n%?\n\n%a\n"
           :empty-lines 1)
          ("n" "Note"   entry
           (file+headline "~/org/notes.org" "Notes")
           "* %^{Title}\n%U\n%?   ; cursor here\n\n%a\n"
           :empty-lines 1)
          ("j" "Journal" entry
           (file+datetree "~/org/journal.org")
           "* %?\nEntered on %U\n%?\n")))
  )

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)" "CANCELLED(c)")))
(setq org-directory "~/org")                      ;; where your .org files live
(setq org-agenda-files (list org-directory))     ;; or a list of files/sub-dirs
(setq org-default-notes-file (expand-file-name "inbox.org" org-directory))
 

(add-hook 'js-mode-hook         #'prettier-mode)
(add-hook 'typescript-mode-hook #'prettier-mode)
(add-hook 'web-mode-hook        #'prettier-mode)
(add-hook 'typescript-mode-hook #'lsp-deferred)

(setq doom-font (font-spec :family "JetBrainsMonoNL Nerd Font Mono" :size 18 :weight 'light))
(custom-set-faces!
  '(mode-line :family "Fira Code Nerd Font Mono" :size 18 :weight regular)
  '(mode-line-inactive :family "Fira Code Nerd Font Mono" :size 18 :weight regular))
(add-to-list 'initial-frame-alist '(width . 200))   ; columns
(add-to-list 'initial-frame-alist '(height . 180))   ; lines

;; Also set default size for every new frame, not just the first one
(add-to-list 'default-frame-alist '(width . 200))
(add-to-list 'default-frame-alist '(height . 180))

(after! lsp-ui
  ;; Enable lsp-ui doc feature
  (setq lsp-ui-doc-enable t
        ;; Place the docs at point (near the symbol) or change to 'bottom
        lsp-ui-doc-position 'bottom
        ;; Optional: if you prefer bottom rather than floating near point
        ;; lsp-ui-doc-position 'bottom
        ;; Side placement when using top/bottom
        ;;lsp-ui-doc-side 'right
        ;; Delay before popup
        lsp-ui-doc-delay 0.2
        ;; Only show docs when you explicitly call it
        lsp-ui-doc-show-with-cursor nil
        lsp-ui-doc-show-with-mouse t)

  ;; Keybindings for docs and peek
  (map! :n "g h" #'lsp-ui-doc-show
        :n "g d" #'lsp-find-definition))

(use-package! eglot-menu
  :commands (eglot-menu-transient)
  :after (eglot transient)
  :config
  (map! :leader
        :desc "Eglot menu" "l m" #'eglot-menu-transient))
(defhydra doom-window-resize-hydra (:hint nil)
  "Resize window"
  ("h" evil-window-decrease-width  "shrink width")
  ("l" evil-window-increase-width  "increase width")
  ("j" evil-window-increase-height "increase height")
  ("k" evil-window-decrease-height "shrink height")
  ("q" nil                          "quit"))
(map! :leader
      :prefix "w"
      :desc "Resize window" :n "SPC" #'doom-window-resize-hydra/body)

;; Zig files
(use-package! zig-ts-mode
  :mode "\\.zig\\'")

;; LSP for Zig
(after! lsp-mode
  (setq lsp-zig-zls-executable "zls"))

(add-hook 'zig-mode-hook #'lsp!)
(add-hook 'zig-ts-mode-hook #'lsp!)
;;Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-rouge)

;(after! doom-major-mode
  ; (add-to-list 'doom-major-mode-list
  ;              '(elixir-ts-mode :lang elixir)))

(after! lsp-mode
  (map! :nv "gh" #'lsp-hover
        :desc "Show LSP hover docs"))
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


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
 ;; or similar depending on setup ;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;;
;; Only activate in a terminal (non-GUI) Emacs session

(unless (display-graphic-p)
  (require 'evil-terminal-cursor-changer)
  (evil-terminal-cursor-changer-activate))


(setq ns-right-alternate-modifier nil)
(customize-set-variable 'mac-option-modifier 'none)
