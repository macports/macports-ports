--- src/main.c	Wed May 13 18:47:17 1998
+++ src/main.c	Thu Feb 17 11:14:33 2005
@@ -164,7 +164,7 @@
 	strcpy(xmgrdir, s);
     }
 #ifndef GR_HELPVIEWER
-    strcpy(help_viewer, "netscape -noraise -remote openURL\\(%s,newwindow\\) >>/dev/null 2>&1 || netscape %s");
+    strcpy(help_viewer, "open\\(%s,newwindow\\) >>/dev/null 2>&1 || open %s");
 #else
     strcpy(help_viewer, GR_HELPVIEWER);
 #endif
