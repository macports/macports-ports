--- src/recnum.c.orig	2011-04-06 19:35:39 UTC
+++ src/recnum.c
@@ -17,7 +17,7 @@ bdb_recnum_init(int argc, VALUE *argv, VALUE obj)
 	argc++;
     }
     rb_hash_aset(argv[argc - 1], array, INT2FIX(0));
-    if (rb_hash_aref(argv[argc - 1], sarray) != RHASH(argv[argc - 1])->ifnone) {
+    if (rb_hash_lookup(argv[argc - 1], sarray) != Qnil) {
 	rb_hash_aset(argv[argc - 1], sarray, INT2FIX(0));
     }
     rb_hash_aset(argv[argc - 1], rb_str_new2("set_flags"), INT2FIX(DB_RENUMBER));
@@ -112,7 +112,9 @@ bdb_intern_shift_pop(VALUE obj, int depart, int len)
     db_recno_t recno;
     VALUE res;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     INIT_TXN(txnid, obj, dbst);
 #if HAVE_DB_CURSOR_4
     bdb_test_error(dbst->dbp->cursor(dbst->dbp, txnid, &dbcp, 0));
@@ -697,8 +699,8 @@ bdb_sary_clear(int argc, VALUE *argv, VALUE obj)
 
     if (argc && TYPE(argv[argc - 1]) == T_HASH) {
 	VALUE f = argv[argc - 1];
-	if ((g = rb_hash_aref(f, rb_intern("flags"))) != RHASH(f)->ifnone ||
-	    (g = rb_hash_aref(f, rb_str_new2("flags"))) != RHASH(f)->ifnone) {
+	if ((g = rb_hash_lookup(f, rb_intern("flags"))) != Qnil ||
+	    (g = rb_hash_lookup(f, rb_str_new2("flags"))) != Qnil) {
 	    flags = NUM2INT(g);
 	}
 	argc--;
@@ -948,7 +950,7 @@ void bdb_init_recnum()
     rb_define_method(bdb_cRecnum, "collect", bdb_sary_collect, -1);
     rb_define_method(bdb_cRecnum, "collect!", bdb_sary_collect_bang, -1);
 #if HAVE_RB_ARY_VALUES_AT
-    rb_define_method(bdb_cRecnum, "map", bdb_sary_collect, 0);
+    rb_define_method(bdb_cRecnum, "map", bdb_sary_collect, -1);
     rb_define_method(bdb_cRecnum, "select", bdb_sary_select, -1);
     rb_define_method(bdb_cRecnum, "values_at", bdb_sary_values_at, -1);
 #endif
