--- xfce4-corner-plugin.c.orig	2006-10-16 11:56:24.000000000 +0200
+++ xfce4-corner-plugin.c	2010-01-24 21:15:50.000000000 +0100
@@ -1,5 +1,6 @@
 #include <gtk/gtk.h>
 #include <libxfce4panel/xfce-panel-plugin.h>
+#include <libxfce4util/libxfce4util.h>
 #include <unistd.h>
 
 typedef enum
