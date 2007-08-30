--- ./yum/sqlutils.py.orig	2007-08-30 15:31:46.000000000 +0200
+++ ./yum/sqlutils.py	2007-08-30 15:38:39.000000000 +0200
@@ -21,7 +21,7 @@
 try:
     import sqlite3 as sqlite
 except ImportError:
-    import sqlite
+    from pysqlite2 import dbapi2 as sqlite
 
 class TokenizeError(Exception):
 	"""Tokenizer error class"""
