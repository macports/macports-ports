--- error.c.orig	2009-07-27 23:14:52.000000000 -0700
+++ error.c	2009-07-27 23:15:02.000000000 -0700
@@ -143,7 +143,7 @@
    off our back.
 */
 void
-yyerror(char *s GCC_UNUSED)
+yyerror(char *s __unused)
 {
     const char *ss = 0;
     struct token_str *p;
