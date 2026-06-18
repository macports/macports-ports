;;  -*- lexical-binding: t; -*-

(setq etags-program-name "etags-emacs")

;; Point native compilation at the MacPorts gcc toolchain so libgccjit can
;; locate its support libraries when Emacs is launched without ${prefix}/bin
;; on PATH.  https://trac.macports.org/ticket/74008
(when (and (fboundp 'native-comp-available-p)
           (native-comp-available-p)
           (not (getenv "GCC_EXEC_PREFIX")))
  (setenv "GCC_EXEC_PREFIX" "__GCC_EXEC_PREFIX__"))
