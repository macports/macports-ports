--- intl/libgnuintl.h.orig	Fri Jun 13 00:48:02 2003
+++ intl/libgnuintl.h	Fri Jun 13 00:49:38 2003
@@ -93,7 +93,7 @@
    If he doesn't, we choose the method.  A third possible method is
    _INTL_REDIRECT_ASM, supported only by GCC.  */
 #if !(defined _INTL_REDIRECT_INLINE || defined _INTL_REDIRECT_MACROS)
-# if __GNUC__ >= 2 && (defined __STDC__ || defined __cplusplus)
+# if __GNUC__ >= 2 && (defined __STDC__ || defined __cplusplus) && !defined __APPLE__
 #  define _INTL_REDIRECT_ASM
 # else
 #  ifdef __cplusplus
