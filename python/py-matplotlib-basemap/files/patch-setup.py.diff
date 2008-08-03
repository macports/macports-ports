--- setup.py.orig	2008-07-31 22:20:38.000000000 -0700
+++ setup.py	2008-07-31 22:41:58.000000000 -0700
@@ -37,7 +37,7 @@
 def checkversion(GEOS_dir):
     """check geos C-API header file (geos_c.h)"""
     try:
-        f = open(os.path.join(GEOS_dir,'include/geos_c.h'))
+        f = open(os.path.join(GEOS_dir,'include/geos2_c.h'))
     except IOError:
         return None
     geos_version = None
@@ -96,7 +96,7 @@
                             library_dirs=geos_library_dirs,
                             runtime_library_dirs=geos_library_dirs,
                             include_dirs=geos_include_dirs,
-                            libraries=['geos_c','geos']))
+                            libraries=['geos2_c','geos2']))
 
 # install shapelib and dbflib.
 packages = packages + ['shapelib','dbflib']
