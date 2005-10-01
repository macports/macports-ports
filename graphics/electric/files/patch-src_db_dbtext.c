--- src/db/dbtext.c.orig	2004-07-15 19:59:51.000000000 -0600
+++ src/db/dbtext.c	2005-10-01 16:53:11.000000000 -0600
@@ -3631,7 +3631,7 @@
 	inf->infstr[inf->infstrptr] = 0;
 }
 
-void addstringtoinfstr(void *vinf, CHAR *pp)
+void addstringtoinfstr(void *vinf, const CHAR *pp)
 {
 	REGISTER CHAR *str;
 	REGISTER INTBIG l, i, ori;
