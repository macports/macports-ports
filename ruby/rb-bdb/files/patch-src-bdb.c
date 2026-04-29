--- src/bdb.c.orig	2011-04-06 19:35:39 UTC
+++ src/bdb.c
@@ -165,12 +165,11 @@ Init_bdb()
     if (rb_const_defined_at(rb_cObject, rb_intern("BDB"))) {
 	rb_raise(rb_eNameError, "module already defined");
     }
     version = rb_tainted_str_new2(db_version(&major, &minor, &patch));
-    if (major != DB_VERSION_MAJOR || minor != DB_VERSION_MINOR
-	|| patch != DB_VERSION_PATCH) {
-        rb_raise(rb_eNotImpError, "\nBDB needs compatible versions of libdb & db.h\n\tyou have db.h version %d.%d.%d and libdb version %d.%d.%d\n",
-		 DB_VERSION_MAJOR, DB_VERSION_MINOR, DB_VERSION_PATCH,
-		 major, minor, patch);
+    if (major != DB_VERSION_MAJOR || minor != DB_VERSION_MINOR) {
+        rb_raise(rb_eNotImpError, "\nBDB needs compatible versions of libdb & db.h\n\tyou have db.h version %d.%d and libdb version %d.%d\n",
+		 DB_VERSION_MAJOR, DB_VERSION_MINOR,
+		 major, minor);
     }
     bdb_mMarshal = rb_const_get(rb_cObject, rb_intern("Marshal"));
     bdb_id_current_db = rb_intern("__bdb_current_db__");
