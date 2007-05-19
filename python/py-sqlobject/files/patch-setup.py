--- setup.py	2007-02-13 12:29:27.000000000 +0100
+++ setup.py.new	2007-03-05 14:26:53.000000000 +0100
@@ -1,13 +1,7 @@
 # ez_setup doesn't work with Python 2.2, so we use distutils
 # in that case:
-try:
-    from ez_setup import use_setuptools
-    use_setuptools()
-    from setuptools import setup
-    is_setuptools = True
-except ImportError:
-    from distutils.core import setup
-    is_setuptools = False
+from distutils.core import setup
+is_setuptools = False
 
 subpackages = ['firebird', 'include', 'include.pydispatch', 'inheritance',
                'manager', 'maxdb', 'mysql', 'mssql', 'postgres', 'sqlite',
