--- setup.py.orig	2007-05-07 14:51:05.000000000 +0100
+++ setup.py	2007-05-07 14:51:41.000000000 +0100
@@ -236,7 +236,7 @@
 else:
     # std setup
     ARGS = {'scripts': ['bzr'],
-            'data_files': [('man/man1', ['bzr.1'])],
+            'data_files': [('share/man/man1', ['bzr.1'])],
             'cmdclass': command_classes,
             'ext_modules': ext_modules,
            }
