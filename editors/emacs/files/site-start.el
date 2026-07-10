;;  -*- lexical-binding: t; -*-

(setq etags-program-name "etags-emacs")

;; Point native compilation at the MacPorts gcc toolchain so libgccjit can
;; locate its support libraries when Emacs is launched without ${prefix}/bin
;; on PATH.  https://trac.macports.org/ticket/74008
(when (and (fboundp 'native-comp-available-p)
           (native-comp-available-p)
           (not (getenv "GCC_EXEC_PREFIX")))
  (setenv "GCC_EXEC_PREFIX" "__GCC_EXEC_PREFIX__"))

;; Load per-package startup snippets that MacPorts elisp ports install into
;; site-lisp/site-start.d/ (e.g. to register their autoloads).  The directory
;; sits next to this file, so derive it from our own location.
(let* ((this-dir (and load-file-name (file-name-directory load-file-name)))
       (site-start-d (and this-dir (expand-file-name "site-start.d" this-dir))))
  (when (and site-start-d (file-directory-p site-start-d))
    (dolist (f (directory-files site-start-d t "\\.el\\'"))
      (condition-case err
          (load f nil t)
        (error (message "site-start.d: error loading %s: %s" f err))))))
