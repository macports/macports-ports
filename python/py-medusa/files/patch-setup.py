--- setup.py.orig	2007-10-16 16:32:28.000000000 -0700
+++ setup.py	2007-10-16 16:33:17.000000000 -0700
@@ -1,6 +1,9 @@
 
 __revision__ = '$Id: setup.py,v 1.9 2003/08/22 13:07:07 akuchling Exp $'
 
+from ez_setup import use_setuptools
+use_setuptools()
+
 from distutils.core import setup
 
 setup(
