--- fortune/fortune.c.orig	Tue Oct  8 17:16:06 2002
+++ fortune/fortune.c	Tue Oct  8 17:16:21 2002
@@ -204,7 +204,7 @@
 #endif
 
 	init_prob();
-	srandomdev();
+	srandom(getpid());
 	do {
 		get_fort();
 	} while ((Short_only && fortlen() > SLEN) ||
