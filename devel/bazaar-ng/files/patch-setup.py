--- setup.py.orig	2007-08-28 15:51:08.000000000 -0400
+++ setup.py	2007-08-28 21:39:28.000000000 -0400
@@ -297,7 +297,7 @@
     DATA_FILES = []
     if not 'bdist_egg' in sys.argv:
         # generate and install bzr.1 only with plain install, not easy_install one
-        DATA_FILES = [('man/man1', ['bzr.1'])]
+        DATA_FILES = [('share/man/man1', ['bzr.1'])]
 
     # std setup
     ARGS = {'scripts': ['bzr'],
