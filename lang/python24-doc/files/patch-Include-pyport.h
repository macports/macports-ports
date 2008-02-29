--- Include/pyport.h.orig	2007-03-12 23:26:06.000000000 -0700
+++ Include/pyport.h	2007-03-12 23:29:35.000000000 -0700
@@ -152,11 +152,23 @@ typedef PY_LONG_LONG		Py_intptr_t;
 #if defined(PYOS_OS2) && defined(PYCC_GCC)
 #include <sys/types.h>
 #endif
+
+#if (defined __APPLE__) && (!defined _POSIX_C_SOURCE)
+#define TEMPORARILY_DEFINING__POSIX_C_SOURCE    /* so we can #undef it later */
+#define _POSIX_C_SOURCE   /* avoid deprecated struct ostat in sys/stat.h */
+#endif
+
 #include <sys/stat.h>
 #elif defined(HAVE_STAT_H)
 #include <stat.h>
 #endif
 
+/* Mac OS X: undefine _POSIX_C_SOURCE if it wasn't defined before */
+#ifdef TEMPORARILY_DEFINING__POSIX_C_SOURCE
+#undef _POSIX_C_SOURCE
+#undef TEMPORARILY_DEFINING__POSIX_C_SOURCE
+#endif
+
 #if defined(PYCC_VACPP)
 /* VisualAge C/C++ Failed to Define MountType Field in sys/stat.h */
 #define S_IFMT (S_IFDIR|S_IFCHR|S_IFREG)
@@ -393,6 +405,7 @@ extern char * _getpty(int *, int, mode_t
 /* BSDI does not supply a prototype for the 'openpty' and 'forkpty'
    functions, even though they are included in libutil. */
 #include <termios.h>
+struct winsize;
 extern int openpty(int *, int *, char *, struct termios *, struct winsize *);
 extern int forkpty(int *, char *, struct termios *, struct winsize *);
 #endif /* !defined(HAVE_PTY_H) && !defined(HAVE_LIBUTIL_H) */
