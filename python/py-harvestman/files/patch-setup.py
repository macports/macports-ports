--- setup.py	Fri Dec 17 09:50:34 2004
+++ ../../setup.py	Wed Jan 12 10:45:32 2005
@@ -14,7 +14,7 @@
 def make_data_files():
     data_files = []
     # Get the install directory
-    sitedir = site_packages_dir()
+    sitedir = os.path.join( "lib","python2.4","site-packages" )
     # Create list for doc directory first.
     # harvestman doc dir
     hdir = os.path.join(sitedir, "HarvestMan", "doc")
@@ -26,13 +26,10 @@
     # Create list for tidy files next
     tidydir = os.path.join(sitedir, "HarvestMan", "tidy")
     tidypath = "HarvestMan/tidy/"
-    data_list = ["".join((tidypath, "cygtidy-0-99-0.dll"))]
     data_files.append((tidydir, data_list))
     
     tidydir = os.path.join(tidydir, "pvt_ctypes")
     data_list = ["".join((tidypath, "pvt_ctypes/README.ctypes")),
-                 "".join((tidypath, "pvt_ctypes/_ctypes.pyd")),
-                 "".join((tidypath, "pvt_ctypes/_ctypes.so")),
                  "".join((tidypath, "pvt_ctypes/ctypes.zip"))]
                  
     data_files.append((tidydir, data_list))
