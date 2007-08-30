--- pm/pm.h.orig	2007-06-21 20:41:58.000000000 +0200
+++ pm/pm.h	2007-08-29 22:41:49.000000000 +0200
@@ -36,7 +36,7 @@
 
 int pm_verify_signature(struct pm_ctx *ctx, const char *path, unsigned flags);
 
-struct pm_dbrec *dbrec;
+extern struct pm_dbrec *dbrec;
 typedef int (*pkgdb_filter_fn) (struct pkgdb *db,
                                 const struct pm_dbrec *dbrec, void *arg);
 
