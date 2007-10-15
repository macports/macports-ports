--- canna/widedef.h.orig	2003-12-28 02:15:20.000000000 +0900
+++ canna/widedef.h	2007-10-16 03:38:13.000000000 +0900
@@ -32,12 +32,12 @@
 #endif
 
 #if (defined(__FreeBSD__) && __FreeBSD_version < 500000) \
-    || defined(__NetBSD__) || defined(__OpenBSD__) || defined(__APPLE__)
+    || defined(__NetBSD__) || defined(__OpenBSD__)
 # include <machine/ansi.h>
 #endif
 
 #if (defined(__FreeBSD__) && __FreeBSD_version < 500000) \
-    || defined(__NetBSD__) || defined(__OpenBSD__) || defined(__APPLE__)
+    || defined(__NetBSD__) || defined(__OpenBSD__)
 # ifdef _BSD_WCHAR_T_
 #  undef _BSD_WCHAR_T_
 #  ifdef WCHAR16
@@ -45,10 +45,6 @@
 #  else
 #   define _BSD_WCHAR_T_ unsigned long
 #  endif
-#  if defined(__APPLE__) && defined(__WCHAR_TYPE__)
-#   undef __WCHAR_TYPE__
-#   define __WCHAR_TYPE__ _BSD_WCHAR_T_
-#  endif
 #  include <stddef.h>
 #  define _WCHAR_T
 # endif
@@ -59,6 +55,14 @@
 # endif
 # include <stddef.h>
 # define _WCHAR_T
+#elif defined(__APPLE__)
+# ifdef WCHAR16
+typedef unsigned short wchar_t;
+# else
+typedef unsigned long wchar_t;
+# endif
+# define _BSD_WCHAR_T_DEFINED_ /* <= 10.3 */
+# define _WCHAR_T /* >= 10.4 */
 #else
 #if !defined(WCHAR_T) && !defined(_WCHAR_T) && !defined(_WCHAR_T_) \
  && !defined(__WCHAR_T) && !defined(_GCC_WCHAR_T) && !defined(_WCHAR_T_DEFINED)
