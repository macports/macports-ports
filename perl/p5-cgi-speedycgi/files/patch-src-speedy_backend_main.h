--- src/speedy_backend_main.h.orig	2003-10-07 00:03:48.000000000 -0400
+++ src/speedy_backend_main.h	2010-01-06 21:26:48.000000000 -0500
@@ -38,7 +38,7 @@
 
 #else
 
-#define speedy_new(s,n,t)	New(123,s,n,t)
+#define speedy_new(s,n,t)	Newx(s,n,t)
 #define speedy_renew		Renew
 #define speedy_free		Safefree
 
