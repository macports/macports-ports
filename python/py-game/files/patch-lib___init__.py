--- lib/__init__.py.orig	2005-07-28 12:35:42.000000000 -0700
+++ lib/__init__.py	2005-07-28 12:36:16.000000000 -0700
@@ -177,7 +177,7 @@
         # went away
         import os, sys
         if (os.getcwd() == '/') and len(sys.argv):
-            os.chdir(os.path.basedir(sys.argv[0]))
+            os.chdir(os.path.dirname(sys.argv[0]))
         return _init()
 
 #cleanup namespace
