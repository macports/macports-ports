--- fig.h	2016-05-15 13:32:23.000000000 -0400
+++ fig.h	2016-05-15 13:33:51.000000000 -0400
@@ -375,6 +375,9 @@
 extern	long		random();
 extern	void		srandom(unsigned int);
 
+#elif defined(__DARWIN__)
+extern  void            srandom();
+
 #elif !defined(__osf__) && !defined(__CYGWIN__) && !defined(linux) && !defined(__FreeBSD__) && !defined(__GLIBC__)
 extern	void		srandom(int);
 
