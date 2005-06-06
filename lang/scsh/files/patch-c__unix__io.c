--- c/unix/io.c.orig	2005-06-05 20:13:47.000000000 -0400
+++ c/unix/io.c	2005-06-05 20:14:00.000000000 -0400
@@ -146,13 +146,13 @@
       return 0; }
 }
 
+static long write_integer(unsigned long n, FILE *port);
+
 long
 ps_write_integer(long n, FILE *port)
 {
   int status;
 
-  static long write_integer(unsigned long n, FILE *port);
-
   if (n == 0) {
     WRITE_CHAR('0', port, status);
     return status; }
