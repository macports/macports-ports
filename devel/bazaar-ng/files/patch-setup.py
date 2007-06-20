--- setup.py.orig	2007-06-18 08:38:53.000000000 -0400
+++ setup.py	2007-06-18 08:38:16.000000000 -0400
@@ -239,7 +239,7 @@
 else:
     # std setup
     ARGS = {'scripts': ['bzr'],
-            'data_files': [('man/man1', ['bzr.1'])],
+            'data_files': [('share/man/man1', ['bzr.1'])],
             'cmdclass': command_classes,
             'ext_modules': ext_modules,
            }
