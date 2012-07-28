--- w_export.c.orig	2007-09-19 15:32:30.000000000 -0400
+++ w_export.c	2012-07-27 17:42:49.000000000 -0400
@@ -1016,7 +1016,7 @@
     /* set global state */
     print_hpgl_pcl_switch = state;
 
-    return;
+    return 0;
 }
 
 static XtCallbackProc
@@ -1038,7 +1038,7 @@
     /* set global state */
     hpgl_specified_font = state;
 
-    return;
+    return 0;
 }
 
 void create_export_panel(Widget w)
