--- setup.py	Thu Jan  6 17:16:13 2005
+++ setup.py.new	Thu Feb 10 01:16:05 2005
@@ -55,6 +55,8 @@
 if os.path.exists(VECLIB_PATH):
     extra_link_args = ['-framework', 'vecLib']
     include_dirs = [os.path.join(VECLIB_PATH, 'Headers')]
+    library_dirs_list = []
+    libraries_list = []
 
 # The packages are split in this way to allow future optional inclusion
 # Numeric package
