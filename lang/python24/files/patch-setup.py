--- setup.py	Wed Mar  9 23:27:24 2005
+++ ../../setup.py	Thu Mar 31 18:34:35 2005
@@ -905,7 +905,8 @@
         self.extensions.extend(exts)
 
         # Call the method for detecting whether _tkinter can be compiled
-        self.detect_tkinter(inc_dirs, lib_dirs)
+        if ("--disable-tk" not in sysconfig.get_config_var("CONFIG_ARGS")):
+            self.detect_tkinter(inc_dirs, lib_dirs)
 
     def detect_tkinter_darwin(self, inc_dirs, lib_dirs):
         # The _tkinter module, using frameworks. Since frameworks are quite
