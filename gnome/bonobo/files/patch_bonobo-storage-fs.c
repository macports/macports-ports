--- storage-modules/bonobo-storage-fs.c.org	Tue Sep 25 01:21:33 2001
+++ storage-modules/bonobo-storage-fs.c	Sun May 19 14:55:09 2002
@@ -329,11 +329,15 @@
 	  CORBA_Environment *ev)
 {
 	BonoboStorageFS *storage_fs = BONOBO_STORAGE_FS (storage);
+	struct stat st;
 	char *full;
 
 	full = g_concat_dir_and_file (storage_fs->path, path);
 
-	if (remove (full) == -1) {
+	/* remove() on Mac OS X(10.0.4) does not remove a directory. */
+	/* if (remove (full) == -1) { */
+	stat (full, &st);
+	if ((S_ISDIR(st.st_mode) ? rmdir (full) : unlink (full)) == -1) {
 
 		if (errno == ENOENT) 
 			CORBA_exception_set (ev, CORBA_USER_EXCEPTION, 
