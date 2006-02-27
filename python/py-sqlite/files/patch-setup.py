--- setup.py.orig	2006-02-27 13:22:00.000000000 -0800
+++ setup.py	2006-02-27 13:22:40.000000000 -0800
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
 
