;; load-path contains ${prefix}/share/emacs/site-lisp and its subdirecotries.
;; See #12115, #29232, #32146.
(setq load-path (cons "__PREFIX__/share/emacs/site-lisp" load-path))
(if (file-readable-p "__PREFIX__/share/emacs/site-lisp")
    (let ((default-directory "__PREFIX__/share/emacs/site-lisp"))
      (if (file-readable-p "__PREFIX__/share/emacs/site-lisp/subdirs.el")
          (load "__PREFIX__/share/emacs/site-lisp/subdirs.el")
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path)))))

;; Info-directory-list contains ${prefix}/share/info. See #32148.
(setq Info-default-directory-list (cons "__PREFIX__/share/info" Info-default-directory-list))

;; Use the OS X Emoji font for Emoticons
(when (fboundp 'set-fontset-font)
  (set-fontset-font t 'emoji '("Apple Color Emoji" . "iso10646-1") nil 'prepend))
