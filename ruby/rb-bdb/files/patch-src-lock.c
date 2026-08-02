--- src/lock.c.orig	2011-04-06 19:35:39 UTC
+++ src/lock.c
@@ -335,7 +335,7 @@ struct lockreq {
 };
 
 static VALUE
-bdb_lockid_each(VALUE obj, VALUE listobj)
+bdb_lockid_each(VALUE obj, VALUE listobj, int _argc, const VALUE *_argv, VALUE _blockarg)
 {
     VALUE key, value;
     DB_LOCKREQ *list;
