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
@@ -488,7 +488,11 @@
                      ORDER BY date DESC LIMIT 1''' % pkg_key
             ocursor = self.oconn.cursor()
             ocursor.execute(query)
-            (author, time_added, changelog) = ocursor.fetchone()
+            row = ocursor.fetchone()
+            if row:
+                (author, time_added, changelog) = row
+            else:
+                (author, time_added, changelog) = (vendor, time_build, "Build")
             # strip email and everything that follows from author
             try:
                 author = author[:author.index('<')].strip()
