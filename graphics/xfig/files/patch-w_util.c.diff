--- w_util.c.orig	2009-03-30 11:52:38.000000000 -0400
+++ w_util.c	2012-07-28 07:31:19.000000000 -0400
@@ -710,7 +710,7 @@
     /* keep track of which one the user is pressing */
     cur_spin = widget;
 
-    return;
+    return 0;
 }
 
 static XtEventHandler
@@ -718,7 +718,7 @@
 {
     XtRemoveTimeOut(auto_spinid);
 
-    return;
+    return 0;
 }
 
 static	XtTimerCallbackProc
@@ -729,7 +729,7 @@
     /* call the proper spinup/down routine */
     XtCallCallbacks(cur_spin, XtNcallback, 0);
 
-    return;
+    return 0;
 }
 
 /***************************/
@@ -1412,7 +1412,7 @@
     }
     SetValues(w);
 
-    return;
+    return 0;
 }
 
 /* assemble main window title bar with xfig title and (base) file name */
