--- shapely/geos.py.orig	2008-07-31 15:01:11.000000000 -0700
+++ shapely/geos.py	2008-07-31 15:01:28.000000000 -0700
@@ -29,8 +29,7 @@
     if lib is None:
         ## try a few more locations
         lib_paths = [
-            # The Framework build from Kyng Chaos:
-            "/Library/Frameworks/GEOS.framework/Versions/Current/GEOS",
+            "@PREFIX@/lib/libgeos_c.dylib"
         ]
         for path in lib_paths:
             if os.path.exists(path):
