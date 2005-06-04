--- archive_platform.h.orig	2005-06-04 02:47:07.000000000 -0400
+++ archive_platform.h	2005-06-04 19:44:08.000000000 -0400
@@ -126,7 +126,7 @@
  * acl_set_file(), we assume it has the rest of the POSIX.1e draft
  * functions used in archive_read_extract.c.
  */
-#if HAVE_SYS_ACL_H && HAVE_ACL_CREATE_ENTRY && HAVE_ACL_INIT && HAVE_ACL_SET_FILE
+#if HAVE_SYS_ACL_H && HAVE_ACL_CREATE_ENTRY && HAVE_ACL_INIT && HAVE_ACL_SET_FILE && !defined(__APPLE__)
 #define	HAVE_POSIX_ACL	1
 #endif
 
