;;  -*- lexical-binding: t; -*-
;;
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

(setq etags-program-name "__APPLICATIONS_DIR__/Emacs.app/Contents/MacOS/bin/etags")

;; Point native compilation at the MacPorts gcc toolchain so libgccjit can
;; locate its support libraries when Emacs is launched without ${prefix}/bin
;; on PATH (e.g. from the Finder).  https://trac.macports.org/ticket/74008
(when (and (fboundp 'native-comp-available-p)
           (native-comp-available-p)
           (not (getenv "GCC_EXEC_PREFIX")))
  (setenv "GCC_EXEC_PREFIX" "__GCC_EXEC_PREFIX__"))

;; Load per-package startup snippets that MacPorts elisp ports install into
;; site-lisp/site-start.d/ (e.g. to register their autoloads).
(let ((site-start-d "__PREFIX__/share/emacs/site-lisp/site-start.d"))
  (when (file-directory-p site-start-d)
    (dolist (f (directory-files site-start-d t "\\.el\\'"))
      (condition-case err
          (load f nil t)
        (error (message "site-start.d: error loading %s: %s" f err))))))
