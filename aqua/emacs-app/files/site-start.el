(setq load-path (cons "__PREFIX__/share/emacs/site-lisp" load-path))
(if (file-readable-p "__PREFIX__/share/emacs/site-lisp/subdirs.el")
    (let ((default-directory "__PREFIX__/share/emacs/site-lisp"))
      (load "__PREFIX__/share/emacs/site-lisp/subdirs.el")))
