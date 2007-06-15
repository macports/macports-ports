--- pub/getopt.c	2005-02-08 11:48:47.000000000 +0000
+++ pub/getopt.c.new	2007-06-13 11:57:57.000000000 +0000
@@ -156,7 +156,7 @@
 /* Value of POSIXLY_CORRECT environment variable.  */
 static char *posixly_correct;
 
-#ifdef	__GNU_LIBRARY__
+#if defined(__GNU_LIBRARY__) || defined(__APPLE__)
 /* We want to avoid inclusion of string.h with non-GNU libraries
    because there are many ways it can cause trouble.
    On some systems, it contains special magic macros that don't work
