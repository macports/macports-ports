--- rmt.c	Wed Dec 20 17:29:07 1995
+++ rmt.c.new	Sun Jan 23 02:26:02 2005
@@ -75,7 +75,6 @@
 char count[SSIZE], mode[SSIZE], pos[SSIZE], op[SSIZE];
 
 extern errno;
-extern char *sys_errlist[];
 char resp[BUFSIZ];
 
 FILE *debug;
