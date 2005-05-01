--- archive_platform.h.orig	2005-04-18 11:36:12.000000000 -0400
+++ archive_platform.h	2005-04-18 11:36:20.000000000 -0400
@@ -124,7 +124,7 @@
  * acl_set_file(), we assume it has the rest of the POSIX.1e draft
  * functions used in archive_read_extract.c.
  */
-#if HAVE_SYS_ACL_H && HAVE_ACL_CREATE_ENTRY && HAVE_ACL_INIT && HAVE_ACL_SET_FILE
+#if HAVE_SYS_ACL_H && HAVE_ACL_CREATE_ENTRY && HAVE_ACL_INIT && HAVE_ACL_SET_FILE && !defined(__APPLE__)
 #define	HAVE_POSIX_ACL	1
 #endif
 
