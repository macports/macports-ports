--- src/output.c.orig	2009-12-19 14:11:52.000000000 -0800
+++ src/output.c	2009-12-19 14:12:43.000000000 -0800
@@ -12,6 +12,7 @@
  */
 
 #include <stdio.h>
+#include <stdlib.h>
 #include <sys/types.h>
 #include <utime.h>
 #include <sys/stat.h>
@@ -737,11 +738,11 @@
                     
                     if (s[0] == '/' && (s[1] == '*' || s[1] == '/'))
                     {
-                        fprintf (output, "%.*s", e_lab - s, s);
+                        fprintf (output, "%.*s", (int) (e_lab - s), s);
                     }
                     else
                     {
-                        fprintf (output, "/* %.*s */", e_lab - s, s);
+                        fprintf (output, "/* %.*s */", (int) (e_lab - s), s);
                     }
                     
                     /* no need to update cur_col: the very next thing will
