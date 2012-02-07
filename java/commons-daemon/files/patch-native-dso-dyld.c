--- src/native/unix/native/dso-dyld.c.orig	2010-03-11 02:03:32.000000000 -0800
+++ src/native/unix/native/dso-dyld.c	2012-02-06 07:59:47.000000000 -0800
@@ -124,8 +124,8 @@
     while (nam[x] != '\0')
         x++;
     und = (char *)malloc(sizeof(char) * (x + 2));
-    while (x >= 0)
-        und[x + 1] = nam[x--];
+    for (; x >= 0; --x)
+    	und[x + 1] = nam[x];
     und[0] = '_';
 
     /* Find the symbol */
