--- ./sqlitecachec.py.orig	2007-05-16 10:10:33.000000000 +0200
+++ ./sqlitecachec.py	2007-06-18 22:00:42.000000000 +0200
@@ -15,7 +15,7 @@
 try:
     import sqlite3 as sqlite
 except ImportError:
-    import sqlite
+    from pysqlite2 import dbapi2 as sqlite
 import _sqlitecache
 
 DBVERSION = _sqlitecache.DBVERSION
