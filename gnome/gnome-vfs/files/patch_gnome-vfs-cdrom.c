--- libgnomevfs/gnome-vfs-cdrom.c.org	Fri Sep 17 13:59:52 2004
+++ libgnomevfs/gnome-vfs-cdrom.c	Fri Sep 17 14:00:01 2004
@@ -143,6 +143,7 @@
 #endif /* defined(__FreeBSD__) */
 	return type;
 #else
+	#if !defined(__APPLE__)
 	*fd = open (vol_dev_path, O_RDONLY|O_NONBLOCK);
 	if (*fd  < 0) {
 		return -1;
@@ -153,6 +154,7 @@
 		return -1;
 	}
 	return ioctl (*fd, CDROM_DISC_STATUS, CDSL_CURRENT);
+	#endif
 #endif
 }
 
