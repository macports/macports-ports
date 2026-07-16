--- w_print.c.orig	2009-04-20 12:26:14.000000000 -0400
+++ w_print.c	2012-07-27 17:47:29.000000000 -0400
@@ -1185,7 +1185,7 @@
     /* which button */
     which = (int) XawToggleGetCurrent(w);
     if (which == 0)		/* no buttons on, in transition so return now */
-	return;
+	return 0;
     if (which == 2)		/* "blank" button, invert state */
 	state = !state;
 
@@ -1193,7 +1193,7 @@
     print_all_layers = state;
     update_figure_size();
 
-    return;
+    return 0;
 }
 
 /* when user toggles between printing all or only active layers */
