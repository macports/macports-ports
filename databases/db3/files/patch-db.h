--- ../build_vxworks/db.h.orig	Fri Jul 13 09:34:27 2001
+++ ../build_vxworks/db.h	Sat Mar  6 07:45:27 2004
@@ -21,6 +21,10 @@
 extern "C" {
 #endif
 
+#ifndef	HAVE_VXWORKS
+#define	HAVE_VXWORKS	1
+#endif
+
 /*
  * XXX
  * Handle function prototypes and the keyword "const".  This steps on name
