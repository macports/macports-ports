--- src/cursor.c.orig	2011-04-06 19:35:39 UTC
+++ src/cursor.c
@@ -29,8 +29,8 @@ bdb_cursor(int argc, VALUE *argv, VALUE obj)
     flags = 0;
     if (argc && TYPE(argv[argc - 1]) == T_HASH) {
 	VALUE g, f = argv[argc - 1];
-	if ((g = rb_hash_aref(f, rb_intern("flags"))) != RHASH(f)->ifnone ||
-	    (g = rb_hash_aref(f, rb_str_new2("flags"))) != RHASH(f)->ifnone) {
+	if ((g = rb_hash_lookup(f, rb_intern("flags"))) != Qnil ||
+	    (g = rb_hash_lookup(f, rb_str_new2("flags"))) != Qnil) {
 	    flags = NUM2INT(g);
 	}
 	argc--;
@@ -67,8 +67,10 @@ bdb_cursor_close(VALUE obj)
     bdb_DBC *dbcst;
     bdb_DB *dbst;
     
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     if (!OBJ_TAINTED(obj) && rb_safe_level() >= 4)
 	rb_raise(rb_eSecurityError, "Insecure: can't close the cursor");
+#endif
     GetCursorDB(obj, dbcst, dbst);
     bdb_test_error(dbcst->dbc->c_close(dbcst->dbc));
     dbcst->dbc = NULL;
@@ -82,7 +84,9 @@ bdb_cursor_del(VALUE obj)
     bdb_DBC *dbcst;
     bdb_DB *dbst;
     
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     GetCursorDB(obj, dbcst, dbst);
     bdb_test_error(dbcst->dbc->c_del(dbcst->dbc, flags));
     return Qtrue;
@@ -353,7 +357,9 @@ bdb_cursor_put(int argc, VALUE *argv, VALUE obj)
     db_recno_t recno;
     int ret;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     MEMZERO(&key, DBT, 1);
     MEMZERO(&data, DBT, 1);
     cnt = rb_scan_args(argc, argv, "21", &a, &b, &c);
