--- error.c.orig	Sun Jan 20 23:43:39 2002
+++ error.c	Tue Dec 10 16:11:55 2002
@@ -468,9 +468,6 @@
 static VALUE *syserr_list;
 #endif
 
-#if !defined(NT) && !defined(__FreeBSD__) && !defined(__NetBSD__) && !defined(__OpenBSD__) && !defined(sys_nerr)
-extern int sys_nerr;
-#endif
 
 static VALUE
 set_syserr(i, name)
