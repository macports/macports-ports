--- setup.py	2005-03-23 19:16:40.000000000 +0100
+++ setup.py	2005-07-11 16:02:23.000000000 +0200
@@ -119,11 +119,10 @@
 
         if sys.platform == "darwin":
             # attempt to make sure we pick freetype2 over other versions
-            add_directory(include_dirs, "/sw/include/freetype2")
-            add_directory(include_dirs, "/sw/lib/freetype2/include")
-            # fink installation directories
-            add_directory(library_dirs, "/sw/lib")
-            add_directory(include_dirs, "/sw/include")
+            add_directory(include_dirs, "__PREFIX__/include/freetype2")
+            # darwinports installation directories
+            add_directory(library_dirs, "__PREFIX__/lib")
+            add_directory(include_dirs, "__PREFIX__/include")
 
         # FIXME: check /opt/stuff directories here?
 
