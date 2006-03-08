--- setup.py	2006-03-08 16:18:22.000000000 +0100
+++ setup.py	2006-03-08 22:33:40.000000000 +0100
@@ -1,7 +1,4 @@
-import ez_setup
-ez_setup.use_setuptools()
-
-from setuptools import setup
+from distutils.core import setup, Extension, Command
 
 import sys
 sys.path.insert(0, 'src')
