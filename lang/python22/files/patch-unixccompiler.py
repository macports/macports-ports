--- Lib/distutils/unixccompiler.py	Sat May 24 00:34:39 2003
+++ Lib/distutils/unixccompiler.py.new	Thu Jan 13 20:51:40 2005
@@ -265,14 +265,7 @@
         # this time, there's no way to determine this information from
         # the configuration data stored in the Python installation, so
         # we use this hack.
-        compiler = os.path.basename(sysconfig.get_config_var("CC"))
-        if sys.platform[:6] == "darwin":
-            # MacOSX's linker doesn't understand the -R flag at all
-            return "-L" + dir
-        if compiler == "gcc" or compiler == "g++":
-            return "-Wl,-R" + dir
-        else:
-            return "-R" + dir
+        return "-L" + dir
 
     def library_option (self, lib):
         return "-l" + lib
