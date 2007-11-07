--- setup.py.orig	2007-10-16 13:29:43.000000000 -0700
+++ setup.py	2007-10-16 13:34:32.000000000 -0700
@@ -5,6 +5,8 @@
 #
 # Usage: python setup.py install
 #
+from ez_setup import use_setuptools
+use_setuptools()
 
 from distutils.core import setup
 
