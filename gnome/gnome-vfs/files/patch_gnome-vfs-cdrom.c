--- libgnomevfs/gnome-vfs-cdrom.c.org	Mon Apr  5 08:17:10 2004
+++ libgnomevfs/gnome-vfs-cdrom.c	Mon Apr  5 08:17:57 2004
@@ -143,8 +143,10 @@
 #endif /* defined(__FreeBSD__) */
 	return type;
 #else
+	#if !defined(__APPLE__)
 	*fd = open (vol_dev_path, O_RDONLY|O_NONBLOCK);
 	return ioctl (*fd, CDROM_DISC_STATUS, CDSL_CURRENT);
+	#endif
 #endif
 }
 
