;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; ==============================
;; Extra tools not provided by Doom modules
;; ==============================
(package! leetcode)
(package! mermaid-mode)
(package! ob-mermaid)

(package! rainbow-delimiters)

(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))


(package! eat)

(package! smudge
  :recipe (:host github :repo "danielfm/smudge"))

(package! elfeed)

(package! markdown-preview-eww)

(package! gleam-ts-mode)

(package! neocaml
  :recipe (:host github :repo "bbatsov/neocaml"))

(package! ocamlformat)

(package! prettier)

(package! terraform-mode)

(package! zig-ts-mode)

(package! coffee-mode)

(package! docker)

(package! eglot-menu
  :recipe (:host github :repo "KarimAziev/eglot-menu"))

(package! evil-terminal-cursor-changer)
