;;; package -- Summary

;;; Commentary:

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(defconst straight-use-package-by-default t)
(defconst straight-cache-autoloads t)  ;; (straight-prune-build) (straight-remove-unused-repos)


;;; Code:
(defun reload-init ()
  "Reload init.el without restarting."
  (interactive)
  (load-file "~/.emacs.d/init.el"))


(defun duplicate-line-or-region (&optional n)
  "Duplicate current line, or region if active.
With argument N, make N copies.
With negative N, comment out original line and use the absolute value.
Taken from https://stackoverflow.com/a/4717026/881224"
  (interactive "*p")
  (let ((use-region (use-region-p)))
    (save-excursion
      (let ((text (if use-region
                      (buffer-substring (region-beginning) (region-end))
                    (prog1 (thing-at-point 'line)
                      (end-of-line)
                      (if (< 0 (forward-line 1))
                          (newline))))))
        (dotimes (i (abs (or n 1)))
          (insert text))))
    (if use-region nil
      (let ((pos (- (point) (line-beginning-position))))
        (if (> 0 n)
            (comment-region (line-beginning-position) (line-end-position)))
        (forward-line 1)
        (forward-char pos)))))

;; ---

(use-package base16-theme
  :bind (([remap count-lines-page] . downcase-region)
         ("C-<f9>" . reload-init)
         ("C-c /" . comment-region)
         ("C-c ?" . uncomment-region)
         ("C-c R" . reverse-region)
         ("C-c S" . sort-lines)
         ("C-c W" . flush-blank-lines)
         ("C-c d" . duplicate-line-or-region)
         ("C-c n" . rename-buffer)
         ("C-c w" . whitespace-cleanup)
         ("C-x !" . winner-undo)
         ("C-x ~" . winner-redo)
         ("M-<down>" . forward-paragraph)
         ("M-<up>" . backward-paragraph)
         ("M-s-<down>" . windmove-down)
         ("M-s-<left>" . windmove-left)
         ("M-s-<right>" . windmove-right)
         ("M-s-<up>" . windmove-up)
         ("s-{" . previous-buffer)
         ("s-}" . next-buffer)
         ("s-k" . kill-this-buffer)
         ("M-k" . nil)
         ("s-u" . revert-buffer)
         ("M-u" . nil)
         )
  :init
  (column-number-mode t)
  (electric-indent-mode 0)
  (global-auto-revert-mode t)
  (global-display-line-numbers-mode t)
  (load-theme 'base16-atelier-forest t)
  (menu-bar-mode -1)
  (put 'downcase-region 'disabled nil)
  (put 'erase-buffer 'disabled nil)
  (put 'upcase-region 'disabled nil)
  (recentf-mode 1)
  (server-start)
  (set-face-attribute 'default nil :height 150)
  (set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%h:"))))
  (setq create-lockfiles nil)
  (setq backup-directory-alist '(("." . "~/.emacs.d/auto-save-list")))
  (setq confirm-kill-emacs 'y-or-n-p)
  (setq inhibit-startup-message t)
  (setq ring-bell-function 'ignore)
  (setq tramp-default-method "ssh")
  (setq-default indent-tabs-mode nil)
  (setq-default truncate-lines 1)
  (show-paren-mode 1)
  (toggle-truncate-lines)
  (tool-bar-mode -1)
  (winner-mode 1)
  )

(straight-use-package 'eglot)
(require 'eglot)
(add-hook 'eglot--managed-mode-hook (lambda () (add-hook 'before-save-hook #'eglot-format-buffer nil nil)))

(use-package exec-path-from-shell
  :config (exec-path-from-shell-initialize))

(use-package helm
  :bind (([remap list-buffers] . helm-buffers-list)
         ("M-x" . helm-M-x)
         ("C-x C-y" . helm-show-kill-ring)
         ("C-x C-f" . helm-find-files)
         ("M-D" . helm-buffer-run-kill-buffers))
  :config
  (helm-mode 1)
  (helm-autoresize-mode 1))


(use-package helm-ag
  :custom '(helm-follow-mode-persistent t)
  :bind ("C-c a g" . helm-do-ag-project-root))

(use-package lsp-mode
  :ensure t)

(straight-use-package 'tree-sitter)
(straight-use-package 'tree-sitter-langs)

;; ---

(use-package emacs-lisp-mode
  :straight nil
  :hook after-init
  :mode "\\.el\\'")

(use-package markdown-mode
  :hook toggle-truncate-lines
  :mode ("\\.text\\'" "\\.markdown\\'" "\\.md\\'")
  :config
  (local-unset-key (kbd "M-<up>"))
  (local-unset-key (kbd "M-<down>"))
  (local-unset-key (kbd "M-<left>"))
  (local-unset-key (kbd "M-<right>")))

(use-package dockerfile-mode
  :mode "Dockerfile\\'")

(use-package nginx-mode
  :mode ("\\'nginx\\.conf\\'"))  ;;  "\\.conf\\'"

(use-package yaml-mode
  :mode ("\\.yaml\\'" "\\.yml\\'"))

;; ---

(use-package json-mode
  :config
  (setq tab-width 2))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package protobuf-mode
  :mode "\\.proto\\'")

(use-package rainbow-mode
  :hook css-mode)

(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'"
  :hook ((rust-mode . flycheck-mode)
         (rust-mode . eglot-ensure)
         (rust-mode . lsp-deferred))
  :config
  (setq rust-format-on-save t))

(use-package toml-mode
  :mode "\\.toml\\'")

(use-package terraform-mode
  :mode "\\.tf\\'")

;; ---

(use-package multiple-cursors
  :bind (("C-c C-S-c" . mc/edit-lines)
         ("C->" . 'mc/mark-next-like-this)
         ("C-<" . 'mc/mark-previous-like-this)
         ("C-c C-<" . 'mc/mark-all-like-this)))


(use-package git-gutter-fringe
  :bind (("C-x a" . git-gutter:stage-hunk)
         ("C-x c o" . git-gutter:revert-hunk))
  :config
  (set-face-foreground 'git-gutter:modified "#CEB300")
  (set-face-background 'git-gutter:modified "#CEB300")
  (set-face-foreground 'git-gutter:added    "#0E3389")
  (set-face-background 'git-gutter:added    "#0E3389")
  (set-face-foreground 'git-gutter:deleted  "#803C3C")
  (set-face-background 'git-gutter:deleted  "#803C3C")
  (git-gutter-mode 1))

(use-package with-editor
  :hook (('shell-mode-hook  'with-editor-export-editor)
         ('shell-mode-hook 'with-editor-export-git-editor)))

(use-package git-commit
  :ensure t
  :init (ignore-errors (magit)))

(provide 'init)
;;; init.el ends here
