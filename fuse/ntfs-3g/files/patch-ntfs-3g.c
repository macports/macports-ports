--- src/ntfs-3g.c.old	2007-04-15 15:13:04.000000000 -0400
+++ src/ntfs-3g.c	2007-04-15 15:12:17.000000000 -0400
@@ -134,7 +134,11 @@
 } opts;
 
 static const char *EXEC_NAME = "ntfs-3g";
+#if (__FreeBSD__ >= 10)
+static char def_opts[] = "silent,nonempty,";
+#else
 static char def_opts[] = "silent,allow_other,nonempty,";
+#endif
 static ntfs_fuse_context_t *ctx;
 static u32 ntfs_sequence;
 
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
