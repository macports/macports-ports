--- lib/libpm.c.orig	2005-06-21 10:50:22.000000000 -0400
+++ lib/libpm.c	2005-06-21 10:53:13.000000000 -0400
@@ -1006,6 +1006,7 @@
     if (c == EOF)
         abortWithReadError(ifP);
     s = c & 0xff;
+    c = getc(ifP);
     if (c == EOF)
         abortWithReadError(ifP);
     s |= (c & 0xff) << 8;
