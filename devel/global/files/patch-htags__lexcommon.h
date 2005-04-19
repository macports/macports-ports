--- htags/lexcommon.h.orig	2005-04-19 09:08:02.000000000 -0400
+++ htags/lexcommon.h	2005-04-19 09:08:05.000000000 -0400
@@ -49,7 +49,7 @@
  * and PREPROCESSOR_LINE as %start values, even if they are not used.
  * It assumed that CPP_COMMENT and SHELL_COMMENT is one line comment.
  */
-static int lineno;
+int lineno;
 static int begin_line;
 /*
  * If you want newline to terminate string, set this variable to 1.
