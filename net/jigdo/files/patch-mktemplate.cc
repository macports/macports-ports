--- src/mktemplate.cc.orig	Sat Jan 31 23:41:44 2004
+++ src/mktemplate.cc	Sat Jan 31 23:47:07 2004
@@ -643,7 +643,7 @@
     Paranoid(*data + len <= bufferLength);
     rsum->addBack(buf + *data, len);
     *data += len; off += len; *n -= len;
-    *rsumBack = modAdd(*rsumBack, len, bufferLength);
+    *rsumBack = modAdd((size_t)*rsumBack, (size_t)len, (size_t)bufferLength);
     Paranoid(off == nextEvent || off == nextAlignedOff);
 #   if DEBUG
     for (unsigned i = 0; i < len; ++i) {
