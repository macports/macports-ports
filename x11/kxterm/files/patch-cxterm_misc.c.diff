--- cxterm/misc.c.orig	Wed Sep 20 18:19:36 1995
+++ cxterm/misc.c	Fri May 14 00:57:56 2004
@@ -796,8 +796,10 @@
 char *SysErrorMsg (n)
     int n;
 {
+#ifndef HAVE_SYS_ERR
     extern char *sys_errlist[];
     extern int sys_nerr;
+#endif
 
     return ((n >= 0 && n < sys_nerr) ? sys_errlist[n] : "unknown error");
 }
