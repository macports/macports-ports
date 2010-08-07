--- fig.h.orig	2008-05-27 12:39:00.000000000 -0500
+++ fig.h	2009-12-21 15:07:15.000000000 -0600
@@ -374,6 +374,9 @@
 extern	long		random();
 extern	void		srandom(unsigned int);
 
+#elif defined(__DARWIN__)
+extern  void            srandom();
+
 #elif !defined(__osf__) && !defined(__CYGWIN__) && !defined(linux) && !defined(__FreeBSD__) && !defined(__GLIBC__)
 extern	void		srandom(int);
 
