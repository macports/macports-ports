--- libvo/gtf.c.orig	2002-08-22 17:03:50.000000000 -0600
+++ libvo/gtf.c	2005-06-10 01:55:52.000000000 -0600
@@ -24,10 +24,10 @@
 
 static GTF_constants GTF_given_constants = { 3.0,550.0,1,8,1.8,8,40,20,128,600 };
 
-static double round(double v) 
+/*static double round(double v) 
 { 
         return floor(v + 0.5); 
-} 
+} */
 	
 static void GetRoundedConstants(GTF_constants *c)
     {
