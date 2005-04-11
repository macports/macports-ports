--- source/term.c.orig	2005-04-03 07:22:04.000000000 -0400
+++ source/term.c	2005-04-03 07:22:41.000000000 -0400
@@ -92,7 +92,6 @@
 #endif
 
 extern  char    *getenv();
-extern	char	*tparm();
 
 /*
  * The old code assumed termcap. termcap is almost always present, but on
