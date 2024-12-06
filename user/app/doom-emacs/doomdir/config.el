;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(setq doom-font (font-spec :family "Inconsolata" :size 27.0))

;; I prefer visual lines
(setq display-line-numbers-type 'visual
      line-move-visual t)
(use-package-hook! evil
  :pre-init
  (setq evil-respect-visual-line-mode t) ;; sane j and k behavior
  t)

;; I also like evil mode visual movement
(map! :map evil-normal-state-map
      :desc "Move to next visual line"
      "j" 'evil-next-visual-line
      :desc "Move to previous visual line"
      "k" 'evil-previous-visual-line)
