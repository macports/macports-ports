--- glib.h.orig	2005-04-18 23:58:21.000000000 -0400
+++ glib.h	2005-04-18 23:58:48.000000000 -0400
@@ -272,7 +272,7 @@
 /* Wrap the gcc __PRETTY_FUNCTION__ and __FUNCTION__ variables with
  * macros, so we can refer to them as strings unconditionally.
  */
-#ifdef	__GNUC__
+#if defined(__GNUC__) && (__GNUC__ < 4)
 #define	G_GNUC_FUNCTION		__FUNCTION__
 #define	G_GNUC_PRETTY_FUNCTION	__PRETTY_FUNCTION__
 #else	/* !__GNUC__ */
