--- setup.py	2003-05-22 19:36:54.000000000 +0200
+++ setup.py	2005-09-29 16:32:09.000000000 +0200
@@ -690,7 +690,8 @@
         self.extensions.extend(exts)
 
         # Call the method for detecting whether _tkinter can be compiled
-        self.detect_tkinter(inc_dirs, lib_dirs)
+        if sysconfig.get_config_var("CONFIG_ARGS").find("--disable-tk") == -1:
+            self.detect_tkinter(inc_dirs, lib_dirs)
 
 
     def detect_tkinter(self, inc_dirs, lib_dirs):
