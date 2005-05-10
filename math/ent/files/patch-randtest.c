--- randtest.c.orig	1998-10-19 14:18:06.000000000 -0600
+++ randtest.c	2005-05-09 21:33:14.000000000 -0600
@@ -22,10 +22,12 @@
 
 /*  LOG2  --  Calculate log to the base 2  */
 
+#ifndef HAVE_LOG2
 static double log2(double x)
 {
     return log2of10 * log10(x);
 }
+#endif
 
 #define MONTEN	6		      /* Bytes used as Monte Carlo
 					 co-ordinates.	This should be no more
