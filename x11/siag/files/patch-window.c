--- xegon/window.c.org	2005-05-31 19:21:24.000000000 +0200
+++ xegon/window.c	2005-05-31 19:22:03.000000000 +0200
@@ -100,7 +100,7 @@
 
 static int bars = 0;
 
-static AppData app_data;
+AppData app_data;
 
 #define XtNplugin "plugin"
 #define XtCPlugin "Plugin"
