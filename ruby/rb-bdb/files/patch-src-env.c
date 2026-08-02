--- src/env.c.orig	2011-04-06 19:35:39 UTC
+++ src/env.c
@@ -508,7 +508,7 @@ bdb_env_set_notify(VALUE obj, VALUE a)
 
 
 static VALUE
-bdb_env_i_options(VALUE obj, VALUE db_stobj)
+bdb_env_i_options(VALUE obj, VALUE db_stobj, int _argc, const VALUE *_argv, VALUE _blockarg)
 {
     char *options;
     DB_ENV *envp;
@@ -1121,9 +1121,11 @@ bdb_env_close(VALUE obj)
 {
     bdb_ENV *envst;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     if (!OBJ_TAINTED(obj) && rb_safe_level() >= 4) {
 	rb_raise(rb_eSecurityError, "Insecure: can't close the environnement");
     }
+#endif
     GetEnvDB(obj, envst);
     bdb_final(envst);
     RDATA(obj)->dfree = free;
@@ -1303,7 +1305,7 @@ bdb_env_each_options(VALUE opt, VALUE stobj)
     DB_ENV *envp;
     struct db_stoptions *db_st;
 
-    res = rb_iterate(rb_each, opt, bdb_env_i_options, stobj);
+    res = rb_block_call(opt, rb_intern("each"), 0, NULL, bdb_env_i_options, stobj);
     Data_Get_Struct(stobj, struct db_stoptions, db_st);
     envp = db_st->env->envp;
 #if HAVE_ST_DB_ENV_SET_LG_BSIZE
@@ -1322,8 +1324,9 @@ bdb_env_each_options(VALUE opt, VALUE stobj)
 }
 
 static VALUE
-bdb_env_s_i_options(VALUE obj, int *flags)
+bdb_env_s_i_options(VALUE obj, VALUE pflags, int _argc, const VALUE *_argv, VALUE _blockarg)
 {
+    int *flags = (int *)pflags;
     char *options;
     VALUE key, value;
 
@@ -1394,7 +1397,7 @@ bdb_env_s_new(int argc, VALUE *argv, VALUE obj)
     envst->envp->db_errcall = bdb_env_errcall;
 #else
     if (argc && TYPE(argv[argc - 1]) == T_HASH) {
-	rb_iterate(rb_each, argv[argc - 1], bdb_env_s_i_options, (VALUE)&flags);
+	rb_block_call(argv[argc - 1], rb_intern("each"), 0, NULL, bdb_env_s_i_options, (VALUE)&flags);
     }
     bdb_test_error(db_env_create(&(envst->envp), flags));
     envst->envp->set_errpfx(envst->envp, "BDB::");
@@ -1406,7 +1409,7 @@ bdb_env_s_new(int argc, VALUE *argv, VALUE obj)
     if (argc && TYPE(argv[argc - 1]) == T_HASH) {
 	VALUE value = Qnil;
 
-	rb_iterate(rb_each, argv[argc - 1], bdb_env_s_j_options, (VALUE)&value);
+	rb_block_call(argv[argc - 1], rb_intern("each"), 0, NULL, bdb_env_s_j_options, (VALUE)&value);
 	if (!NIL_P(value)) {
 	    if (!rb_respond_to(value, bdb_id_call)) {
 		rb_raise(bdb_eFatal, "arg must respond to #call");
@@ -1517,12 +1520,16 @@ bdb_env_init(int argc, VALUE *argv, VALUE obj)
 	flags = NUM2INT(c);
         break;
     }
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     if (flags & DB_CREATE) {
 	rb_secure(4);
     }
+#endif
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 1
     if (flags & DB_USE_ENVIRON) {
 	rb_secure(1);
     }
+#endif
 #ifndef BDB_NO_THREAD_COMPILE
     if (!(envst->options & BDB_NO_THREAD)) {
 	bdb_set_func(envst);
@@ -1658,7 +1665,9 @@ bdb_env_s_remove(int argc, VALUE *argv, VALUE obj)
     char *db_home;
     int flag = 0;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 2
     rb_secure(2);
+#endif
     if (rb_scan_args(argc, argv, "11", &a, &b) == 2) {
 	flag = NUM2INT(b);
     }
@@ -2445,7 +2454,7 @@ bdb_env_rep_set_nsites(VALUE obj, VALUE a)
 }
 
 static VALUE
-bdb_env_rep_get_nsites(VALUE obj, VALUE a)
+bdb_env_rep_get_nsites(VALUE obj)
 {
     bdb_ENV *envst;
     int offon;
@@ -2470,7 +2479,7 @@ bdb_env_rep_set_priority(VALUE obj, VALUE a)
 }
 
 static VALUE
-bdb_env_rep_get_priority(VALUE obj, VALUE a)
+bdb_env_rep_get_priority(VALUE obj)
 {
     bdb_ENV *envst;
     int offon;
@@ -2764,7 +2773,7 @@ bdb_env_rep_set_clockskew(VALUE obj, VALUE a, VALUE b)
 }
 
 static VALUE
-bdb_env_rep_get_clockskew(VALUE obj, VALUE a)
+bdb_env_rep_get_clockskew(VALUE obj)
 {
     bdb_ENV *envst;
     u_int32_t fast, slow;
@@ -2791,7 +2800,7 @@ bdb_env_rep_set_request(VALUE obj, VALUE a, VALUE b)
 }
 
 static VALUE
-bdb_env_rep_get_request(VALUE obj, VALUE a)
+bdb_env_rep_get_request(VALUE obj)
 {
     bdb_ENV *envst;
     u_int32_t frmin, frmax;
@@ -3012,7 +3021,7 @@ void bdb_init_env()
     rb_define_method(bdb_cEnv, "rep_timeout?", bdb_env_rep_intern_timeout, 1);
 #endif
 #if HAVE_ST_DB_ENV_REP_STAT
-    rb_define_method(bdb_cEnv, "rep_stat", bdb_env_rep_stat, 0);
+    rb_define_method(bdb_cEnv, "rep_stat", bdb_env_rep_stat, -1);
 #endif
 #if HAVE_ST_DB_ENV_REP_SYNC
     rb_define_method(bdb_cEnv, "rep_sync", bdb_env_rep_sync, -1);
