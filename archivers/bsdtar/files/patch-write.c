--- write.c.orig	2005-04-12 22:18:30.000000000 -0400
+++ write.c	2005-04-12 22:19:00.000000000 -0400
@@ -982,7 +982,7 @@
 	le->links = st->st_nlink - 1;
 }
 
-#ifdef HAVE_POSIX_ACL
+#if defined(HAVE_POSIX_ACL) && !defined(__APPLE__)
 void			setup_acl(struct bsdtar *bsdtar,
 			     struct archive_entry *entry, const char *accpath,
 			     int acl_type, int archive_entry_acl_type);
