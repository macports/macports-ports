--- gnomevfs/src/gnomevfs.h	Mon Nov 24 03:50:06 2003
+++ ../ruby-gnome2-all-0.8.1-patched/gnomevfs/src/gnomevfs.h	Fri Feb 20 02:31:31 2004
@@ -112,12 +112,12 @@
 
 /* Global Variables **********************************************************/
 
-VALUE g_id_call;		/* rb_intern("call") */
+extern VALUE g_id_call;		/* rb_intern("call") */
 
-VALUE g_gvfs_uri;		/* GnomeVFS::URI */
-VALUE g_gvfs_error;		/* GnomeVFS::Error */
-VALUE g_gvfs_file;		/* GnomeVFS::File */
-VALUE g_gvfs_dir;		/* GnomeVFS::Directory */
+extern VALUE g_gvfs_uri;		/* GnomeVFS::URI */
+extern VALUE g_gvfs_error;		/* GnomeVFS::Error */
+extern VALUE g_gvfs_file;		/* GnomeVFS::File */
+extern VALUE g_gvfs_dir;		/* GnomeVFS::Directory */
 
 /* End of Multiple Inclusion Guard and extern "C" specifiers for C++ *********/
 
