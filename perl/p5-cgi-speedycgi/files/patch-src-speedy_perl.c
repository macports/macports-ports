--- src/speedy_perl.c.orig	2009-07-23 21:26:43.000000000 +0200
+++ src/speedy_perl.c	2009-07-23 21:26:47.000000000 +0200
@@ -818,7 +818,7 @@
     my_call_sv(get_perlvar(&PERLVAR_RESET_GLOBALS));
 
     /* Copy option values in from the perl vars */
-    if (SvIV(PERLVAL_OPTS_CHANGED)) {
+    if (SvTRUE(PERLVAL_OPTS_CHANGED)) {
 	int i;
 	for (i = 0; i < SPEEDY_NUMOPTS; ++i) {
 	    OptRec *o = speedy_optdefs + i;
