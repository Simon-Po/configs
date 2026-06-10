;;; zenzen-light-theme.el --- Light Zenzen variant -- lexical-binding: t; no-byte-compile: t; --

(require 'doom-themes)

(def-doom-theme zenzen-light
  "A calm, light Zenburn-inspired theme."

  ;; name        default
  ((bg         '("#ECEAE4"))   ;; darker warm paper
   (bg-alt     '("#E3E0D9"))
   (base0      '("#FFFFFF"))
   (base1      '("#D8D5CE"))
   (base2      '("#ECEAE4"))
   (base3      '("#E3E0D9"))
   (base4      '("#C2BFB7"))
   (base5      '("#B4B1AA"))
   (base6      '("#A6A39C"))
   (base7      '("#98958E"))
   (base8      '("#3A3A3A"))   ;; softer dark anchor
   (fg         '("#3A3A3A"))   ;; no pure black
   (fg-alt     '("#7A7A72"))

   ;; Core palette (soft Zenburn hues adapted for light bg)
   (grey       base4)
   (red        '("#B56C6C"))
   (red-1      '("#9E5C5C"))
   (orange     '("#C9976B"))
   (green      '("#6F8F6F"))
   (teal       '("#3FA4AA"))
   (yellow     '("#C2A96A"))
   (blue       '("#5FA8AD"))
   (dark-blue  '("#4A6FA5"))
   (magenta    '("#B57FA3"))
   (violet     '("#8F88C0"))
   (cyan       '("#5FA8AD"))
   (dark-cyan  '("#4C8C8C"))

   ;; Extra
   (green-2    '("#5F7F5F"))
   (green+1    '("#7FA77F"))
   (green+2    '("#8FBF8F"))
   (blue-1     '("#6F9FA3"))

   ;; Comment grey (slightly green-tinted like zenburn)
   (comment-grey '("#8F968F"))

   ;; custom
   (red-calm "#8C6666")

   ;; Face categories
   (highlight      blue)
   (vertical-bar   (doom-darken base1 0.05))
   (selection      '("#D8E1EA"))
   (builtin        fg)
   (comments       comment-grey)
   (doc-comments   comment-grey)
   (constants      red-1)
   (functions      cyan)
   (keywords       yellow)
   (methods        cyan)
   (operators      blue)
   (type           blue-1)
   (strings        green-2)
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
   (modeline-fg     fg)
   (modeline-bg     base1)
   (modeline-bg-l   bg)
   (modeline-bg-inactive   bg-alt)
   (modeline-bg-inactive-l bg-alt))

  ;; Face overrides
  ((cursor :foreground bg :background base8)

   (tuareg-font-double-semicolon-face
    :foreground red-calm)

   (copilot-overlay-face
    :foreground dark-cyan
    :slant 'italic)

   ;; Comments
   (font-lock-comment-face
    :foreground comment-grey
    :slant 'italic)

   (font-lock-doc-face
    :foreground comment-grey
    :slant 'italic)

   (font-lock-comment-delimiter-face
    :foreground comment-grey
    :slant 'italic)

   ;; Strings
   (font-lock-string-face
    :foreground green-2)

   ;; Minor tuning
   (line-number :foreground base6)
   (line-number-current-line :foreground yellow)
   (highlight :background base3)

   (mode-line :background modeline-bg :foreground modeline-fg)
   (mode-line-inactive :background modeline-bg-inactive :foreground fg-alt)))

;;; zenzen-light-theme.el ends here
