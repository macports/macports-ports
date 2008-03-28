--- thunar-vfs/thunar-vfs-mime-database.c.old	2007-01-20 14:39:09.000000000 -0600
+++ thunar-vfs/thunar-vfs-mime-database.c	2007-09-10 02:55:00.000000000 -0500
@@ -1122,11 +1122,20 @@
             }
 #elif defined(HAVE_FGETXATTR)
           /* check for valid mime type stored in the extattr (Linux) */
+#if defined(__APPLE__)
+          nbytes = fgetxattr (fd, "user.mime_type", NULL, 0, 0, 0);
+#else
           nbytes = fgetxattr (fd, "user.mime_type", NULL, 0);
+#endif
           if (G_UNLIKELY (nbytes >= 3))
             {
               buffer = g_newa (gchar, nbytes + 1);
+#if defined(__APPLE__)
+              nbytes = fgetxattr (fd, "user.mime_type", buffer, nbytes, 0, 0);
+#else
               nbytes = fgetxattr (fd, "user.mime_type", buffer, nbytes);
+#endif
+	
               if (G_LIKELY (nbytes >= 3))
                 {
                   buffer[nbytes] = '\0';
