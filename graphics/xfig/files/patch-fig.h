--- fig.h.orig	2007-04-15 07:40:32.000000000 +0900
+++ fig.h	2007-04-15 07:41:02.000000000 +0900
@@ -383,7 +383,7 @@
 extern	long		random();
 extern	void		srandom(unsigned int);
 
-#elif !defined(__osf__) && !defined(__CYGWIN__) && !defined(linux)
+#elif !defined(__osf__) && !defined(__CYGWIN__) && !defined(linux) && !defined(__DARWIN__)
 extern	void		srandom(int);
 
 #endif
