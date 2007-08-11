--- src/ntfs-3g.c.old	2007-07-10 00:25:15.000000000 +0200
+++ src/ntfs-3g.c	2007-08-09 14:58:09.000000000 +0200
@@ -2170,7 +2170,11 @@
 		fstype = load_fuse_module();
 	
 	create_dev_fuse();
-#endif	
+#else
+#if (__FreeBSD__ >= 10)
+	fstype = FSTYPE_FUSE;
+#endif
+#endif
 	
 	if (stat(opts.device, &sbuf)) {
 		ntfs_log_perror("Failed to access '%s'", opts.device);
