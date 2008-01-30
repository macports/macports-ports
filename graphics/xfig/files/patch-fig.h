--- fig.h.orig	2007-11-06 17:31:17.000000000 +0100
+++ fig.h	2007-11-06 17:31:57.000000000 +0100
@@ -383,6 +383,9 @@
 extern	long		random();
 extern	void		srandom(unsigned int);
 
+#elif defined(__DARWIN__)
+extern  void            srandom();
+
 #elif !defined(__osf__) && !defined(__CYGWIN__) && !defined(linux)
 extern	void		srandom(int);
