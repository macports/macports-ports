--- libgnomevfs/gnome-vfs-utils.c.org	Thu Jul 24 16:16:25 2003
+++ libgnomevfs/gnome-vfs-utils.c	Thu Jul 24 16:18:09 2003
@@ -42,6 +42,9 @@
 #include <string.h>
 #include <sys/stat.h>
 #include <sys/types.h>
+#include <sys/param.h>
+#include <sys/mount.h>
+#define HAVE_STATVFS 0
 #include <unistd.h>
 
 #if HAVE_SYS_STATVFS_H
