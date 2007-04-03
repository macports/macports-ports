--- setup.py.orig	2007-04-02 09:28:26.000000000 -0400
+++ setup.py	2007-04-02 09:28:59.000000000 -0400
@@ -217,7 +217,7 @@
 else:
     # std setup
     ARGS = {'scripts': ['bzr'],
-            'data_files': [('man/man1', ['bzr.1'])],
+            'data_files': [('share/man/man1', ['bzr.1'])],
             'cmdclass': {'build': bzr_build,
                          'install_scripts': my_install_scripts,
                         },
