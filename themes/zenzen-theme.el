;;; zenzen-theme.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2026 Simon Pohl
;;
;; Author: Simon Pohl <spohl@Mac>
;; Maintainer: Simon Pohl <spohl@Mac>
;; Created: February 16, 2026
;; Modified: February 16, 2026
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/spohl/zenzen-theme
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:
;;; zenzen-theme.el --- Calm Zenburn refinement -*- lexical-binding: t; no-byte-compile: t; -*-

(require 'doom-themes)

(def-doom-theme zenzen
  "A calmer, refined Zenburn variant."

  ;; name        default
  ((bg         '("#3F3F3F"))
   (bg-alt     '("#383838"))
   (base0      '("#000000"))
   (base1      '("#2B2B2B"))
   (base2      '("#3F3F3F")) ;; was #303030 — now matches bg (fixes vterm)
   (base3      '("#383838"))
   (base4      '("#494949"))
   (base5      '("#4F4F4F"))
   (base6      '("#5F5F5F"))
   (base7      '("#6F6F6F"))
   (base8      '("#FFFFEF"))
   (fg         '("#DCDCDC"))
   (fg-alt     '("#989890"))

   ;; Core palette
   (grey       base4)
   (red        '("#CC9393"))
   (red-1      '("#BC8383"))
   (orange     '("#DFAF8F"))
   (green      '("#7F9F7F"))
   (teal       '("#4db5bd"))
   (yellow     '("#F0DFAF"))
   (blue       '("#8CD0D3"))
   (dark-blue  '("#2257A0"))
   (magenta    '("#DC8CC3"))
   (violet     '("#a9a1e1"))
   (cyan       '("#93E0E3"))
   (dark-cyan  '("#5699AF"))

   ;; Extra
   (green-2    '("#6F8F6F"))
   (green+1    '("#8FB28F"))
   (green+2    '("#9FC59F"))
   (blue-1     '("#7CB8BB"))

   ;; New unified comment grey
   (comment-grey '("#9FAFAF"))
   
   ;; custom
   (red-calm "#946B6B")
   
  

   ;; Face categories
   (highlight      blue)
   (vertical-bar   (doom-darken base1 0.1))
   (selection      dark-blue)
   (builtin        fg)
   (comments       comment-grey)
   (doc-comments   comment-grey)
   (constants      red-1)
   (functions      cyan)
   (keywords       yellow)
   (methods        cyan)
   (operators      blue)
   (type           blue-1)
   (strings        green-2) ;; darker green strings
   (variables      orange)
   (numbers        fg)
   (region         base1)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    orange)
   (vc-added       green)
   (vc-deleted     red)

 

   ;; Modeline
   (modeline-fg     green+1)
   (modeline-bg     base3)
   (modeline-bg-l   bg)
   (modeline-bg-inactive   bg)
   (modeline-bg-inactive-l bg-alt))

  ;; Face overrides
  ((cursor :foreground fg :background base8)
   (tuareg-font-double-semicolon-face
 :foreground red-calm)
   ;; Unified comments
   (font-lock-comment-face
    :foreground comment-grey
    :slant 'italic)

   (font-lock-doc-face
    :foreground comment-grey
    :slant 'italic)

   (font-lock-comment-delimiter-face
    :foreground comment-grey
    :slant 'italic)

   ;; Strings (ensures override)
   (font-lock-string-face
    :foreground green-2)

   ;; Minor tuning
   (line-number :foreground base7)
   (line-number-current-line :foreground yellow)
   (highlight :background base4)
   (mode-line :background modeline-bg :foreground modeline-fg)
   (mode-line-inactive :background modeline-bg-inactive :foreground fg-alt)))

;;; zenzen-theme.el ends here
