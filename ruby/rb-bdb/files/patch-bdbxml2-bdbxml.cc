--- bdbxml2/bdbxml.cc.orig	2011-04-06 19:35:39 UTC
+++ bdbxml2/bdbxml.cc
@@ -392,9 +392,11 @@ xb_env_free(bdb_ENV *envst)
 static VALUE
 xb_env_close(VALUE obj)
 {
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     if (!OBJ_TAINTED(obj) && rb_safe_level() >= 4) {
 	rb_raise(rb_eSecurityError, "Insecure: can't close the environnement");
     }
+#endif
     bdb_ENV *envst;
     GetEnvDBErr(obj, envst, id_current_env, xb_eFatal);
     xb_final(envst);
@@ -743,7 +745,9 @@ xb_man_type_set(VALUE obj, VALUE a)
 static VALUE
 xb_man_rename(VALUE obj, VALUE a, VALUE b)
 {
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 2
     rb_secure(2);
+#endif
     XmlTransaction *xmltxn = get_txn(obj);
     xman *man = get_man_txn(obj);
     char *oldname = StringValuePtr(a);
@@ -760,7 +764,9 @@ xb_man_rename(VALUE obj, VALUE a, VALUE b)
 static VALUE
 xb_man_remove(VALUE obj, VALUE a)
 {
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 2
     rb_secure(2);
+#endif
     XmlTransaction *xmltxn = get_txn(obj);
     xman *man = get_man_txn(obj);
     char *name = StringValuePtr(a);
@@ -843,7 +849,9 @@ xb_man_verify(int argc, VALUE *argv, VALUE obj)
     VALUE a, b, c, d;
     int flags = 0;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     switch (rb_scan_args(argc, argv, "12", &a, &b, &c, &d)) {
     case 4:
         flags = NUM2INT(d);
@@ -885,7 +893,9 @@ xb_man_load_con(int argc, VALUE *argv, VALUE obj)
     unsigned long lineno = 0;
     bool freeupd = true;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 2
     rb_secure(2);
+#endif
     xman *man = get_man(obj);
     switch (rb_scan_args(argc, argv, "22", &a, &b, &c, &d)) {
     case 4:
@@ -1028,7 +1038,9 @@ xb_man_reindex(int argc, VALUE *argv, VALUE obj)
     bool freeupd = true;
     int flags = 0;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 2
     rb_secure(2);
+#endif
     XmlTransaction *xmltxn = get_txn(obj);
     xman *man = get_man_txn(obj);
     switch (rb_scan_args(argc, argv, "12", &a, &b, &c)) {
@@ -1125,7 +1137,9 @@ xb_man_compact_con(int argc, VALUE *argv, VALUE obj)
     bool freeupd = true;
     int flags = 0;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 2
     rb_secure(2);
+#endif
     XmlTransaction *xmltxn = get_txn(obj);
     xman *man = get_man_txn(obj);
     switch (rb_scan_args(argc, argv, "11", &a, &b)) {
@@ -1168,7 +1182,9 @@ xb_man_truncate_con(int argc, VALUE *argv, VALUE obj)
     bool freeupd = true;
     int flags = 0;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 2
     rb_secure(2);
+#endif
     XmlTransaction *xmltxn = get_txn(obj);
     xman *man = get_man_txn(obj);
     switch (rb_scan_args(argc, argv, "11", &a, &b)) {
@@ -1274,9 +1290,11 @@ xb_int_open_con(int argc, VALUE *argv, VALUE obj, VALU
     if (rb_scan_args(argc, argv, "11", &a, &b) == 2) {
         flags = NUM2INT(b);
     }
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     if (flags && DB_CREATE) {
         rb_secure(4);
     }
+#endif
     char *name = StringValuePtr(a);
     xman *man = get_man_txn(obj);
     XmlTransaction *xmltxn = get_txn(obj);
@@ -1315,7 +1333,9 @@ xb_int_create_con(int argc, VALUE *argv, VALUE obj, VA
     XmlContainer *xmlcon;
     xcon *con;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     xman *man = get_man_txn(obj);
     XmlTransaction *xmltxn = get_txn(obj);
     if (argc == 1) {
@@ -1965,7 +1985,9 @@ xb_con_add(int argc, VALUE *argv, VALUE obj)
     bool freeupd = true;
     int flags = 0;
     
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     xcon *con = get_con(obj);
     XmlTransaction *xmltxn = get_con_txn(con);
     rb_scan_args(argc, argv, "13", &a, &b, &c, &d);
@@ -2062,7 +2084,9 @@ xb_con_update(int argc, VALUE *argv, VALUE obj)
     XmlUpdateContext *xmlupd = 0;
     bool freeupd = true;
     
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     xcon *con = get_con(obj);
     XmlTransaction *xmltxn = get_con_txn(con);
     if (rb_scan_args(argc, argv, "11", &a, &b) == 2) {
@@ -2098,7 +2122,9 @@ xb_con_delete(int argc, VALUE *argv, VALUE obj)
     XmlUpdateContext *xmlupd = 0;
     bool freeupd = true;
     
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     xcon *con = get_con(obj);
     XmlTransaction *xmltxn = get_con_txn(con);
     if (rb_scan_args(argc, argv, "11", &a, &b) == 2) {
@@ -2554,7 +2580,9 @@ xb_con_index_set(int argc, VALUE *argv, VALUE obj)
     bool freeupd = true;
     VALUE a, b;
     
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     xcon *con = get_con(obj);
     XmlTransaction *xmltxn = get_con_txn(con);
     if (rb_scan_args(argc, argv, "11", &a, &b) == 2) {
@@ -3176,7 +3204,9 @@ xb_man_create_look(int argc, VALUE *argv, VALUE obj)
     XmlIndexLookup::Operation xmlop = XmlIndexLookup::EQ;
     VALUE a, b, c, d, e, f, res;
 
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     xman *man = get_man_txn(obj);
     switch(rb_scan_args(argc, argv, "42", &a, &b, &c, &d, &e, &f)) {
     case 6:
@@ -4392,7 +4422,9 @@ xb_mod_execute(int argc, VALUE *argv, VALUE obj)
     bool freeupd = true, freecxt = true;
     VALUE a, b, c;
     
+#if defined(RUBY_SAFE_LEVEL_MAX) && RUBY_SAFE_LEVEL_MAX >= 4
     rb_secure(4);
+#endif
     switch (rb_scan_args(argc, argv, "12", &a, &b, &c)) {
     case 3:
     {
@@ -5536,18 +5568,16 @@ extern "C" {
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
 
         xb_mObs = rb_const_get(rb_cObject, rb_intern("ObjectSpace"));
