--- etc/cnid_dbd/dbif.c.orig	2004-12-22 02:36:12.000000000 +1300
+++ etc/cnid_dbd/dbif.c
@@ -514,7 +514,11 @@ int dbif_count(const int dbi, u_int32_t 
     DB_BTREE_STAT *sp;
     DB *db = db_table[dbi].db;
 
+#if DB_VERSION_MAJOR == 4 && DB_VERSION_MINOR >= 3
+    ret = db->stat(db, NULL, &sp, 0);
+#else
     ret = db->stat(db, &sp, 0);
+#endif
 
     if (ret) {
         LOG(log_error, logtype_cnid, "error getting stat infotmation on database: %s", db_strerror(errno));

