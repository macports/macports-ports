--- ./libxfce4menu/xfce-menu-item-cache.c.orig	2009-02-24 02:04:57.000000000 +0100
+++ ./libxfce4menu/xfce-menu-item-cache.c	2009-03-01 23:22:00.000000000 +0100
@@ -42,6 +42,10 @@
 
 #include <libxfce4util/libxfce4util.h>
 
+#ifdef HAVE_SYS_TYPES_H
+#include <sys/types.h>
+#endif
+
 #include <tdb/tdb.h>
 
 #include <libxfce4menu/xfce-menu-item.h>
