;; Look in MacPorts ${prefix} for tree-sitter parser libraries
(when (boundp 'treesit-extra-load-path)
  (setq treesit-extra-load-path (cons "__PREFIX__/lib" treesit-extra-load-path)))
