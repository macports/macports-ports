--- setup.py.orig	2006-10-27 18:52:02.000000000 +0200
+++ setup.py	2006-10-27 19:31:56.000000000 +0200
@@ -207,7 +207,7 @@
 else:
     # std setup
     ARGS = {'scripts': ['bzr'],
-            'data_files': [('man/man1', ['bzr.1'])],
+            'data_files': [('share/man/man1', ['bzr.1'])],
             'cmdclass': {'build': bzr_build,
                          'install_scripts': my_install_scripts,
                         },
