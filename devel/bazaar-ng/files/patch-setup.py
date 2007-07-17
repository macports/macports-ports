--- setup.py.orig	2007-07-16 23:53:29.000000000 -0400
+++ setup.py	2007-07-17 08:30:21.000000000 -0400
@@ -245,7 +245,7 @@
 else:
     # std setup
     ARGS = {'scripts': ['bzr'],
-            'data_files': [('man/man1', ['bzr.1'])],
+            'data_files': [('share/man/man1', ['bzr.1'])],
             'cmdclass': command_classes,
             'ext_modules': ext_modules,
            }
