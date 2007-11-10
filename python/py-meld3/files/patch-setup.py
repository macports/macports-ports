--- setup.py.orig	2007-10-16 16:08:20.000000000 -0700
+++ setup.py	2007-10-16 16:09:22.000000000 -0700
@@ -1,3 +1,5 @@
+from ez_setup import use_setuptools
+use_setuptools()
 from distutils.core import setup, Extension
 import os
 
