--- buildtools/libopt.c.orig	Wed Nov  8 20:00:24 2006
+++ buildtools/libopt.c	Wed Aug 15 22:10:53 2007
@@ -306,6 +306,11 @@
         */
         *valid_library_p = FALSE;
         *error_p = FALSE;
+    } else if (strcmp(lastdot, ".la") == 0) {
+        /* Skip conversion of GNU libtool library files.
+        */
+        *valid_library_p = FALSE;
+        *error_p = FALSE;
     } else {
         unsigned int prefix_length;
         bool prefix_good;
