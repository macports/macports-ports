--- setup.py.orig	2007-11-09 08:19:32.000000000 -0500
+++ setup.py	2007-11-12 18:01:19.000000000 -0500
@@ -321,7 +321,7 @@
     DATA_FILES = []
     if not 'bdist_egg' in sys.argv:
         # generate and install bzr.1 only with plain install, not easy_install one
-        DATA_FILES = [('man/man1', ['bzr.1'])]
+        DATA_FILES = [('share/man/man1', ['bzr.1'])]
 
     # std setup
     ARGS = {'scripts': ['bzr'],
