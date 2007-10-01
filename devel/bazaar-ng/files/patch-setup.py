--- setup.py.orig	2007-09-25 22:47:54.000000000 -0400
+++ setup.py	2007-09-26 11:29:44.000000000 -0400
@@ -320,7 +320,7 @@
     DATA_FILES = []
     if not 'bdist_egg' in sys.argv:
         # generate and install bzr.1 only with plain install, not easy_install one
-        DATA_FILES = [('man/man1', ['bzr.1'])]
+        DATA_FILES = [('share/man/man1', ['bzr.1'])]
 
     # std setup
     ARGS = {'scripts': ['bzr'],
