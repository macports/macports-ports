--- setup.py	2006-04-12 19:39:57.000000000 +0200
+++ work/pysqlite-2.2.0/setup.py	2006-04-12 19:43:21.000000000 +0200
@@ -104,11 +104,11 @@
         print "Fatal error: PYSQLITE_VERSION could not be detected!"
         sys.exit(1)
 
-    data_files = [("pysqlite2-doc",
+    data_files = [("share/doc/py-sqlite",
                         glob.glob("doc/*.html") \
                       + glob.glob("doc/*.txt") \
                       + glob.glob("doc/*.css")),
-                   ("pysqlite2-doc/code",
+                   ("share/doc/py-sqlite/code",
                         glob.glob("doc/code/*.py"))]
 
     py_modules = ["sqlite"]
