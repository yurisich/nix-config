;;; package -- Summary

;;; Commentary:

;;; Code:
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(add-to-list 'exec-path "/usr/local/bin/")

(setq package-enable-at-startup nil)

(defconst straight-fix-flycheck t)
(defconst straight-check-for-modifications '(watch-files find-when-checking))

(provide 'early-init)
;;; early-init.el ends here
