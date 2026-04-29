--- src/log.c.orig	2011-04-06 19:35:39 UTC
+++ src/log.c
@@ -688,7 +688,7 @@ bdb_log_unregister(VALUE obj)
 void bdb_init_log()
 {
     rb_define_method(bdb_cEnv, "log_put", bdb_s_log_put, -1);
-    rb_define_method(bdb_cEnv, "log_curlsn", bdb_s_log_curlsn, 0);
+    rb_define_method(bdb_cEnv, "log_curlsn", bdb_s_log_curlsn, 1);
     rb_define_method(bdb_cEnv, "log_checkpoint", bdb_s_log_checkpoint, 1);
     rb_define_method(bdb_cEnv, "log_flush", bdb_s_log_flush, -1);
     rb_define_method(bdb_cEnv, "log_stat", bdb_env_log_stat, -1);
