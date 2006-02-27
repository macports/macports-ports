--- setup.py	2005-10-02 00:59:54.000000000 +0200
+++ setup.py	2006-02-27 23:05:28.000000000 +0100
@@ -1,9 +1,7 @@
 # ez_setup doesn't work with Python 2.2, so we use distutils
 # in that case:
 try:
-    from ez_setup import use_setuptools
-    use_setuptools()
-    from setuptools import setup
+	from distutils.core import setup, Extension, Command
 except ImportError:
     from distutils.core import setup
 
