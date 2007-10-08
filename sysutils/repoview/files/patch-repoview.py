--- repoview.py.orig	2007-08-09 00:14:08.000000000 +0200
+++ repoview.py	2007-08-09 00:16:14.000000000 +0200
@@ -53,7 +53,7 @@
 try:
     import sqlite3 as sqlite
 except ImportError:
-    import sqlite
+    from pysqlite2 import dbapi2 as sqlite
 
 ##
 # Some hardcoded constants
