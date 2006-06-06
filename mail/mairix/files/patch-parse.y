--- dfasyn/parse.y.orig	2006-02-20 23:41:02.000000000 +0100
+++ dfasyn/parse.y	2006-06-07 01:05:08.000000000 +0200
@@ -71,7 +71,7 @@
 
 %token LSQUARE RSQUARE
 %token LSQUARE_CARET
-%token CHAR HYPHEN;
+%token CHAR HYPHEN
 
 %right QUERY COLON
 %left PIPE
