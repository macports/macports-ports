--- src/ntfs-3g.c.old	2007-04-15 15:13:04.000000000 -0400
+++ src/ntfs-3g.c	2007-04-15 15:12:17.000000000 -0400
@@ -2124,12 +2128,16 @@
 		goto err_out;
 	}
 
+#if (__FreeBSD__ >= 10)
+	fstype = FSTYPE_FUSE;
+#else
 #ifdef linux
 	fstype = get_fuse_fstype();
 	if (fstype == FSTYPE_NONE || fstype == FSTYPE_UNKNOWN)
 		fstype = load_fuse_module();
 #endif	
 	create_dev_fuse();
+#endif
 	
 	if (stat(opts.device, &sbuf)) {
 		ntfs_log_perror("Failed to access '%s'", opts.device);
