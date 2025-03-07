--- bdbxml1/bdbxml.cc.orig	2011-04-06 19:35:39 UTC
+++ bdbxml1/bdbxml.cc
@@ -1148,15 +1148,19 @@ xb_con_init(int argc, VALUE *argv, VALUE obj)
 	    flags = NUM2INT(b);
 	}
     }
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 2
     if (flags & DB_TRUNCATE) {
 	rb_secure(2);
     }
+#endif
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     if (flags & DB_CREATE) {
 	rb_secure(4);
     }
     if (rb_safe_level() >= 4) {
 	flags |= DB_RDONLY;
     }
+#endif
     if (!txn && con->env_val) {
 	bdb_ENV *envst = NULL;
 	GetEnvDBErr(con->env_val, envst, id_current_env, xb_eFatal);
@@ -1179,9 +1183,11 @@ xb_con_close(int argc, VALUE *argv, VALUE obj)
     xcon *con;
     int flags = 0;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     if (!OBJ_TAINTED(obj) && rb_safe_level() >= 4) {
 	rb_raise(rb_eSecurityError, "Insecure: can't close the container");
     }
+#endif
     Data_Get_Struct(obj, xcon, con);
     if (!con->closed && con->con) {
 	if (rb_scan_args(argc, argv, "01", &a)) {
@@ -1516,7 +1522,9 @@ xb_int_update(int argc, VALUE *argv, VALUE obj, XmlUpd
     DbTxn *txn;
     VALUE a;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     GetConTxn(obj, con, txn);
     if (rb_scan_args(argc, argv, "10", &a) != 1) {
 	rb_raise(rb_eArgError, "invalid number of arguments (%d for 1)", argc);
@@ -1545,7 +1553,9 @@ xb_int_push(int argc, VALUE *argv, VALUE obj, XmlUpdat
     VALUE a, b;
     int flags = 0;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     GetConTxn(obj, con, txn);
     if (rb_scan_args(argc, argv, "11", &a, &b) == 2) {
 	flags = NUM2INT(b);
@@ -1775,7 +1785,9 @@ xb_int_delete(int argc, VALUE *argv, VALUE obj, XmlUpd
     VALUE a, b;
     int flags = 0;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     GetConTxn(obj, con, txn);
     if (rb_scan_args(argc, argv, "11", &a, &b) == 2) {
 	flags = NUM2INT(b);
@@ -1824,7 +1836,9 @@ xb_con_remove(int argc, VALUE *argv, VALUE obj)
     xcon *con;
     DbTxn *txn = NULL;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 2
     rb_secure(2);
+#endif
     if (rb_scan_args(argc, argv, "11", &a, &b) == 2) {
 	flags = NUM2INT(b);
     }
@@ -1844,7 +1858,9 @@ xb_con_rename(int argc, VALUE *argv, VALUE obj)
     char *str;
     DbTxn *txn = NULL;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 2
     rb_secure(2);
+#endif
     if (rb_scan_args(argc, argv, "21", &a, &b, &c) == 3) {
 	flags = NUM2INT(c);
     }
@@ -2340,18 +2356,16 @@ extern "C" {
 	major = NUM2INT(rb_const_get(xb_mDb, rb_intern("VERSION_MAJOR")));
 	minor = NUM2INT(rb_const_get(xb_mDb, rb_intern("VERSION_MINOR")));
 	patch = NUM2INT(rb_const_get(xb_mDb, rb_intern("VERSION_PATCH")));
-	if (major != DB_VERSION_MAJOR || minor != DB_VERSION_MINOR
-	    || patch != DB_VERSION_PATCH) {
-	    rb_raise(rb_eNotImpError, "\nBDB::XML needs compatible versions of BDB\n\tyou have BDB::XML version %d.%d.%d and BDB version %d.%d.%d\n",
-		     DB_VERSION_MAJOR, DB_VERSION_MINOR, DB_VERSION_PATCH,
-		     major, minor, patch);
+	if (major != DB_VERSION_MAJOR || minor != DB_VERSION_MINOR) {
+	    rb_raise(rb_eNotImpError, "\nBDB::XML needs compatible versions of BDB\n\tyou have BDB::XML version %d.%d and BDB version %d.%d\n",
+		     DB_VERSION_MAJOR, DB_VERSION_MINOR,
+		     major, minor);
 	}
 	version = rb_tainted_str_new2(dbxml_version(&major, &minor, &patch));
-	if (major != DBXML_VERSION_MAJOR || minor != DBXML_VERSION_MINOR
-	    || patch != DBXML_VERSION_PATCH) {
-	    rb_raise(rb_eNotImpError, "\nBDB::XML needs compatible versions of DbXml\n\tyou have DbXml.hpp version %d.%d.%d and libdbxml version %d.%d.%d\n",
-		     DB_VERSION_MAJOR, DB_VERSION_MINOR, DB_VERSION_PATCH,
-		     major, minor, patch);
+	if (major != DBXML_VERSION_MAJOR || minor != DBXML_VERSION_MINOR) {
+	    rb_raise(rb_eNotImpError, "\nBDB::XML needs compatible versions of DbXml\n\tyou have DbXml.hpp version %d.%d and libdbxml version %d.%d\n",
+		     DB_VERSION_MAJOR, DB_VERSION_MINOR,
+		     major, minor);
 	}
 
 	xb_eFatal = rb_const_get(xb_mDb, rb_intern("Fatal"));
@@ -2477,7 +2491,7 @@ extern "C" {
 	rb_define_method(xb_cUpd, "<<", RMF(xb_upd_add), 1);
 	rb_define_method(xb_cUpd, "delete", RMF(xb_upd_delete), -1);
 	rb_define_method(xb_cUpd, "update", RMF(xb_upd_update), -1);
-	xb_cTmp = rb_define_class_under(xb_mXML, "Tmp", rb_cData);
+	xb_cTmp = rb_define_class_under(xb_mXML, "Tmp", rb_cObject);
 	rb_undef_method(CLASS_OF(xb_cTmp), "allocate");
 	rb_undef_method(CLASS_OF(xb_cTmp), "new");
 	rb_define_method(xb_cTmp, "[]", RMF(xb_cxt_name_get), 1);
