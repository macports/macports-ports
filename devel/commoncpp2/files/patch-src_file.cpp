--- src/file.cpp.orig	Fri Jun  6 17:16:46 2003
+++ src/file.cpp	Thu Feb  5 02:05:39 2004
@@ -80,7 +80,9 @@
 #endif
 
 #ifdef	MACOSX
+#ifndef MACOSX_WITH_LOCKF
 #define	MISSING_LOCKF
+#endif
 #endif
 
 #ifndef	F_LOCK
