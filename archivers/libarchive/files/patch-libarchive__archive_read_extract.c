--- libarchive/archive_read_extract.c.orig	2006-11-06 18:44:54.000000000 -0800
+++ libarchive/archive_read_extract.c	2006-11-06 18:45:16.000000000 -0800
@@ -1435,11 +1435,9 @@
 #ifndef HAVE_POSIX_ACL
 /* Default empty function body to satisfy mainline code. */
 static int
-set_acls(struct archive *a, int fd, struct archive_entry *entry)
+set_acls(struct archive *a)
 {
 	(void)a;
-	(void)fd;
-	(void)entry;
 
 	return (ARCHIVE_OK);
 }
