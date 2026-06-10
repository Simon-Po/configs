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
;;
;;
;;
;;
;; dual display stuff
;; Force straight's transient before git-commit starts.
;;
;;

(after! leetcode
  (setq leetcode-save-solutions t
        leetcode-directory "~/dev/priv/leetcode"))

(after! lsp-mode
  (lsp-register-client
   (make-lsp-client
    :new-connection
    (lsp-tramp-connection '("/home/sp/go/bin/gopls"))
    :major-modes '(go-mode go-ts-mode)
    :remote? t
    :server-id 'gopls-tramp)))

(defun sim-open-file-line-at-point ()
  "Open a /path/to/file:line reference at point."
  (interactive)
  (let* ((line-text
          (buffer-substring-no-properties
           (line-beginning-position)
           (line-end-position)))
         (path-line-regexp
          "\\(/[^ \n\t]+\\):\\([0-9]+\\)"))
    (unless (string-match path-line-regexp line-text)
      (user-error "No /path/to/file:line reference found on this line"))
    (let ((file (match-string 1 line-text))
          (line (string-to-number (match-string 2 line-text))))
      (find-file file)
      (goto-char (point-min))
      (forward-line (1- line)))))
;;
(defun sim-copy-file-line ()
  "Copy current file path with line number, like /path/to/file:57."
  (interactive)
  (unless buffer-file-name
    (user-error "Current buffer is not visiting a file"))
  (let ((link (format "%s:%d"
                      (file-truename buffer-file-name)
                      (line-number-at-pos))))
    (kill-new link)
    (message "Copied %s" link)))
;; Why: Emacs 30's built-in transient is older than Doom's pinned Magit expects.
(defun sim/load-straight-transient ()
  (let* ((transient-straight-dir
          (expand-file-name
           (format "straight/build-%d.%d/transient"
                   emacs-major-version emacs-minor-version)
           doom-local-dir))
         (transient-straight-file
          (expand-file-name "transient.el" transient-straight-dir)))
    (when (file-directory-p transient-straight-dir)
      (add-to-list 'load-path transient-straight-dir))
    (when (and (featurep 'transient)
               (not (fboundp 'transient--set-layout)))
      (unload-feature 'transient t))
    (cond
     ((fboundp 'transient--set-layout) t)
     ((file-exists-p transient-straight-file)
      (load transient-straight-file nil 'nomessage)
      (fboundp 'transient--set-layout))
     ((require 'transient nil t)
      (fboundp 'transient--set-layout)))))

(defun sim/enable-global-git-commit-mode ()
  (if (sim/load-straight-transient)
      (global-git-commit-mode)
    (warn "Could not load a new enough transient for git-commit")))

(remove-hook 'doom-first-file-hook #'global-git-commit-mode)
(add-hook 'doom-first-file-hook #'sim/enable-global-git-commit-mode)

(setq dired-use-ls-dired nil)

(defun my/send-buffer-to-other-frame ()
  (interactive)
  (let ((buf (current-buffer)))
    (other-frame 1)
    (switch-to-buffer buf)
    (other-frame -1)
    (bury-buffer)))
;; Shortcut to notes
(defun sim-notes ()
  (interactive)
  (let ((choice (read-char-choice
                 "Open: [p] Projects, [m] Meetings, [g] General: "
                 '(?p ?m))))
    (dired
     (cond
      ((eq choice ?g) "~/notes/")
      ((eq choice ?p) "~/notes/Projects/")
      ((eq choice ?m) "~/notes/meetings/")))))
(defun sim--open-from-dir (base)
  (let* ((dirs (seq-filter
                #'file-directory-p
                (directory-files base t "^[^.]" t)))
         (choice (completing-read "Select: " dirs)))
    (dired choice)))


(defun sim-work ()
  (interactive)
  (sim--open-from-dir "~/dev/wip/"))

(defun sim-priv ()
  (interactive)
  (sim--open-from-dir "~/dev/priv/"))

(defun sim-doom-config ()
  (interactive)
  (dired "~/.config/doom")
  )

(defun sim-daily ()
  "Open daily notes and jump to today's header, creating it if needed."
  (interactive)
  (let* ((file "/Users/spohl/notes/daily_notes.md")
         (date (format-time-string "%d.%m.%Y"))
         (header (concat "## " date)))
    (find-file file)
    (goto-char (point-min))
    (if (re-search-forward
         (concat "^" (regexp-quote header) "$")
         nil
         t)
        (progn
          (end-of-line)
          (forward-line 1))
      (goto-char (point-max))
      (unless (bolp)
        (insert "\n"))
      (insert "\n" header "\n\n"))))

(global-set-key (kbd "C-c o") #'other-frame)
(global-set-key (kbd "C-c O") #'my/display-buffer-in-other-frame)
;;; Copilot configuration
(defvar sim-copilot-enabled nil
  "Whether Copilot is currently enabled globally.")

(defun sim-toggle-copilot ()
  "Toggle Copilot globally and disable company completion when Copilot is active."
  (interactive)
  (require 'copilot)
  (setq sim-copilot-enabled (not sim-copilot-enabled))

  (if sim-copilot-enabled
      (progn
        (message "turning on Copilot")

        ;; enable copilot automatically in programming buffers
        (unless (member #'copilot-mode prog-mode-hook)
          (add-hook 'prog-mode-hook #'copilot-mode))

        ;; update existing buffers
        (dolist (buf (buffer-list))
          (with-current-buffer buf
            (when (derived-mode-p 'prog-mode)
              (copilot-mode 1)
              (company-mode -1)))))   ;; disable completion popup

    (message "turning off Copilot")

    ;; stop enabling copilot for new buffers
    (remove-hook 'prog-mode-hook #'copilot-mode)

    ;; update existing buffers
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (derived-mode-p 'prog-mode)
          (copilot-mode -1)
          (company-mode 1))))))      ;; restore completion popup


(after! copilot
  ;; smoother Copilot suggestions
  (setq copilot-idle-delay 0.35
        copilot-log-level 'error
        copilot-max-char-warning-disable t)

  ;; keybinding for toggle
  (map! :leader
        :desc "Toggle Copilot globally"
        "t C" #'sim-toggle-copilot)

  ;; accept suggestions
  (map! :map copilot-completion-map
        "<tab>" #'copilot-accept-completion
        "TAB" #'copilot-accept-completion
        "C-<tab>" #'copilot-accept-completion-by-word))(add-to-list 'warning-suppress-types '(copilot))

;; (use-package! copilot
;;   :hook (prog-mode . copilot-mode))
;;
(setenv "DOTNET_ROOT" "/opt/homebrew/opt/dotnet/libexec")
(add-to-list 'exec-path "/opt/homebrew/opt/dotnet/libexec")
(after! lsp-mode
  (setq lsp-csharp-server-path "/Users/spohl/.local/opt/csharp-lsp/OmniSharp")
  (setq lsp-clojure-server-path "/opt/homebrew/opt/clojure-lsp-native/bin/clojure-lsp")
  (setq lsp-zig-zls-executable "/opt/homebrew/bin/zls")
  (setq lsp-zig-zig-exe-path "/opt/homebrew/bin/zig")
  )
(after! lsp-mode
  (setq lsp-gopls-server-path "gopls"))
(add-to-list 'exec-path "/Users/spohl/.dotnet/tools")
(setenv "PATH" (concat "/Users/spohl/.dotnet/tools:" (getenv "PATH")))

(after! lsp-fsharp
  (setq lsp-fsharp-server-path "/Users/spohl/.dotnet/tools/fsautocomplete"))

;;; --- ncspot integration ---
(defun ncspot ()
  "Toggle ncspot in a dedicated popup vterm buffer."
  (interactive)
  (let ((buffer-name "*ncspot*"))
    (if (get-buffer-window buffer-name)
        ;; If visible → close it
        (delete-window (get-buffer-window buffer-name))
      ;; Else → open or reuse buffer
      (progn
        (unless (get-buffer buffer-name)
          (with-current-buffer (vterm buffer-name)
            ;; Prevent vterm from asking about killing processes
            (setq-local confirm-kill-processes nil)
            (vterm-send-string "ncspot")
            (vterm-send-return)))
        (pop-to-buffer buffer-name)))))

;; Tell Doom to treat it as a stable popup
(set-popup-rule! "^\\*ncspot\\*$"
  :side 'bottom
  :size 0.35
  :select t
  :quit nil
  :ttl nil)

;; Optional: leader key binding
(map! :leader
      :desc "Toggle ncspot"
      "o m" #'ncspot)


(add-hook 'text-mode-hook #'visual-line-mode)
(add-hook 'org-mode-hook #'visual-line-mode)
(add-hook 'markdown-mode-hook #'visual-line-mode)
(add-hook 'vterm-mode-hook
          (lambda ()
            (solaire-mode -1)))

(add-to-list 'custom-theme-load-path "~/.config/themes/")
(setq doom-theme 'zenzen)

(add-hook! 'doom-load-theme-hook
  (when (eq doom-theme 'doom-zenburn)
    (custom-set-faces!
      '(font-lock-string-face
        :foreground "#6F8F6F")

      '(font-lock-comment-face
        :foreground "#9FAFAF"
        :slant italic)

      '(font-lock-doc-face
        :foreground "#9FAFAF"
        :slant italic)

      '(font-lock-comment-delimiter-face
        :foreground "#9FAFAF"
        :slant italic))))

(use-package! neocaml)

(after! ocaml
  (add-to-list 'auto-mode-alist '("\\.ml\\'"  . tuareg-mode))
  (add-to-list 'auto-mode-alist '("\\.mli\\'" . tuareg-mode)))
(after! tuareg
  (add-hook 'tuareg-mode-hook #'lsp!))
(add-to-list 'auto-mode-alist '("\\.exs\\'" . elixir-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ex\\'" . elixir-ts-mode))
(after! lsp-elixir
  (setq lsp-elixir-dialyzer-enabled nil
        lsp-elixir-suggest-specs nil))

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
        lsp-ui-doc-show-with-mouse nil)

  ;; Keybindings for docs and peek
  (map! :n "g h" #'lsp-ui-doc-show
        :n "g d" #'lsp-find-definition))

(use-package! eglot-menu
  :commands (eglot-menu-transient)
  :after (eglot transient)
  :config
  (map! :leader
        :desc "Eglot menu" "l m" #'eglot-menu-transient))

(add-hook 'clojure-mode-hook #'rainbow-delimiters-mode)
(add-hook 'clojurescript-mode-hook #'rainbow-delimiters-mode)
(add-hook 'clojurec-mode-hook #'rainbow-delimiters-mode)

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
