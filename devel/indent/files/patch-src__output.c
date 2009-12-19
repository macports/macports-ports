--- src/output.c.orig	2008-03-11 11:50:42.000000000 -0700
+++ src/output.c	2009-12-19 14:22:32.000000000 -0800
@@ -749,11 +749,11 @@
 
          if (s[0] == '/' && (s[1] == '*' || s[1] == '/'))
          {
-            fprintf (output, "%.*s", e_lab - s, s);
+            fprintf (output, "%.*s", (int) (e_lab - s), s);
          }
          else
          {
-            fprintf (output, "/* %.*s */", e_lab - s, s);
+            fprintf (output, "/* %.*s */", (int) (e_lab - s), s);
          }
 
         /* no need to update cur_col: the very next thing will
