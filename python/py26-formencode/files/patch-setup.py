--- setup.py	2005-11-21 01:08:17.000000000 +0100
+++ setup.py	2006-03-06 19:33:06.000000000 +0100
@@ -1,6 +1,4 @@
-from ez_setup import use_setuptools
-use_setuptools()
-from setuptools import setup
+from distutils.core import setup, Extension, Command
 
 version = '0.4'
 
