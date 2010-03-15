--- src/native/unix/native/dso-dyld.c.orig	2004-02-09 07:55:21.000000000 -0800
+++ src/native/unix/native/dso-dyld.c	2005-01-22 08:27:20.000000000 -0800
@@ -118 +118 @@
-    while(x>=0) und[x+1]=nam[x--];
+    for(; x>=0; --x) und[x+1]=nam[x];
