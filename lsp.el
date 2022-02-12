;;; lsp.el -*- lexical-binding: t; -*-
(after! lsp-mode
  (lsp-ui-mode)
  (lsp-ui-doc-enable t)
  (setq lsp-ui-doc-delay 0.4
	lsp-ui-doc-position 'top
	lsp-ui-doc-max-height 12
	lsp-ui-doc-max-width 90
	lsp-ui-doc-show-with-cursor t
	lsp-ui-doc-show-with-mouse t)
  (defun efs/lsp-mode-setup ()
    (setq lsp-headerline-breadcrumb-mode '(path-up-to-project file symbols))
    (lsp-headerline-breadcrumb-mode))
  (efs/lsp-mode-setup))
