--- src/io-utils.c.orig	Tue Feb 13 16:38:06 2001
+++ src/io-utils.c	Thu Feb 19 16:26:11 2004
@@ -71,7 +71,7 @@
 
 double __plinf;
 double __neinf;
-double __nan;
+double __o_nan;
 
 char nname[] = "#NOT_A_NUMBER";
 char iname[] = "#INFINITY";
@@ -125,7 +125,7 @@
   __neinf = divide (-1., 0.);
   (void) signal (SIGFPE, ignore_sig);
 #endif
-  __nan = __plinf + __neinf;
+  __o_nan = __plinf + __neinf;
 }
 
 
