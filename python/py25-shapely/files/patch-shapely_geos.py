--- shapely/geos.py.orig	2008-11-19 09:31:43.000000000 +0300
+++ shapely/geos.py	2008-11-19 09:31:25.000000000 +0300
@@ -27,6 +27,8 @@
     if lib is None:
         ## try a few more locations
         lib_paths = [
+            # local macports
+            '@PREFIX@/lib/libgeos_c.dylib',
             # The Framework build from Kyng Chaos:
             "/Library/Frameworks/GEOS.framework/Versions/Current/GEOS",
             # macports
