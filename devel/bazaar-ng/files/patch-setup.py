--- setup.py.orig	2007-03-14 23:14:14.000000000 -0400
+++ setup.py	2007-03-14 23:14:44.000000000 -0400
@@ -219,7 +219,7 @@
 else:
     # std setup
     ARGS = {'scripts': ['bzr'],
-            'data_files': [('man/man1', ['bzr.1'])],
+            'data_files': [('share/man/man1', ['bzr.1'])],
             'cmdclass': {'build': bzr_build,
                          'install_scripts': my_install_scripts,
                         },
