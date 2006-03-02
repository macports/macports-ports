--- setup.py	2006-02-02 12:01:31.000000000 +0100
+++ setup.py	2006-03-02 19:55:53.000000000 +0100
@@ -23,10 +23,11 @@
 
 import glob, os, sys
 
-from ez_setup import use_setuptools
-use_setuptools()
+#from ez_setup import use_setuptools
+#use_setuptools()
 
-from setuptools import setup, Extension
+#from setuptools import setup, Extension
+from distutils.core import setup, Extension, Command
 
 # If you need to change anything, it should be enough to change setup.cfg.
 
@@ -90,11 +91,11 @@
 
 def main():
     build_docs()
-    data_files = [("pysqlite2-doc",
+    data_files = [("share/doc/py-sqlite",
                         glob.glob("doc/*.html") \
                       + glob.glob("doc/*.txt") \
                       + glob.glob("doc/*.css")),
-                   ("pysqlite2-doc/code",
+                   ("share/doc/py-sqlite/code",
                         glob.glob("doc/code/*.py"))]
 
     if sys.platform == "win32":
