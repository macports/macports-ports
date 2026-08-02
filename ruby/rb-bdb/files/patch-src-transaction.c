--- src/transaction.c.orig	2011-04-06 19:35:39 UTC
+++ src/transaction.c
@@ -139,7 +139,9 @@ bdb_txn_commit(int argc, VALUE *argv, VALUE obj)
     VALUE a;
     int flags;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     flags = 0;
     if (rb_scan_args(argc, argv, "01", &a) == 1) {
         flags = NUM2INT(a);
@@ -205,7 +207,7 @@ bdb_txn_unlock(VALUE txnv)
 }
 
 static VALUE
-bdb_catch(VALUE val, VALUE args, VALUE self)
+bdb_catch(VALUE val, VALUE args, int _argc, const VALUE *_argv, VALUE _blockarg)
 {
     rb_yield(args);
     return Qtrue;
@@ -260,7 +262,7 @@ struct dbtxnopt {
 };
 
 static VALUE
-bdb_txn_i_options(VALUE obj, VALUE dbstobj)
+bdb_txn_i_options(VALUE obj, VALUE dbstobj, int _argc, const VALUE *_argv, VALUE _blockarg)
 {
     struct dbtxnopt *opt = (struct dbtxnopt *)dbstobj;
     VALUE key, value;
@@ -329,7 +331,7 @@ bdb_env_rslbl_begin(VALUE origin, int argc, VALUE *arg
     if (argc > 0 && TYPE(argv[argc - 1]) == T_HASH) {
 	options = argv[argc - 1];
 	argc--;
-	rb_iterate(rb_each, options, bdb_txn_i_options, (VALUE)&opt);
+	rb_block_call(options, rb_intern("each"), 0, NULL, bdb_txn_i_options, (VALUE)&opt);
 	flags = opt.flags;
 	if (flags & BDB_TXN_COMMIT) {
 	    commit = 1;
@@ -552,7 +554,9 @@ bdb_env_recover(VALUE obj)
     if (!rb_block_given_p()) {
         rb_raise(bdb_eFatal, "call out of an iterator");
     }
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     GetEnvDB(obj, envst);
     txnv = Data_Make_Struct(bdb_cTxn, bdb_TXN, bdb_txn_mark, bdb_txn_free, txnst);
     txnst->env = obj;
@@ -584,7 +588,9 @@ bdb_txn_discard(VALUE obj)
     bdb_TXN *txnst;
     int flags;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     flags = 0;
     GetTxnDB(obj, txnst);
 #if HAVE_ST_DB_TXN_DISCARD
@@ -761,7 +767,9 @@ bdb_env_dbremove(int argc, VALUE *argv, VALUE obj)
     bdb_TXN *txnst;
     DB_TXN *txnid;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 2
     rb_secure(2);
+#endif
     a = b = c = Qnil;
     file = database = NULL;
     flags = 0;
@@ -810,7 +818,9 @@ bdb_env_dbrename(int argc, VALUE *argv, VALUE obj)
     bdb_TXN *txnst;
     DB_TXN *txnid;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 2
     rb_secure(2);
+#endif
     a = b = c = Qnil;
     file = database = newname = NULL;
     flags = 0;
