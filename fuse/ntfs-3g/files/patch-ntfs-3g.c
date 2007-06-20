--- src/ntfs-3g.c.old	2007-06-20 00:20:09.000000000 -0700
+++ src/ntfs-3g.c	2007-06-20 00:21:06.000000000 -0700
@@ -2157,7 +2157,11 @@
 	fstype = get_fuse_fstype();
 	if (fstype == FSTYPE_NONE || fstype == FSTYPE_UNKNOWN)
 		fstype = load_fuse_module();
-#endif	
+#else
+#if (__FreeBSD__ >= 10)
+	fstype = FSTYPE_FUSE;
+#endif
+#endif
 	create_dev_fuse();
 	
 	if (stat(opts.device, &sbuf)) {
