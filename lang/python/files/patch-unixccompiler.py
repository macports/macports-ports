--- Lib/distutils/unixccompiler.py.orig	Thu Oct 24 19:57:16 2002
+++ Lib/distutils/unixccompiler.py	Thu Oct 24 19:57:35 2002
@@ -253,23 +253,7 @@
         return "-L" + dir
 
     def runtime_library_dir_option (self, dir):
-        # XXX Hackish, at the very least.  See Python bug #445902:
-        # http://sourceforge.net/tracker/index.php
-        #   ?func=detail&aid=445902&group_id=5470&atid=105470
-        # Linkers on different platforms need different options to
-        # specify that directories need to be added to the list of
-        # directories searched for dependencies when a dynamic library
-        # is sought.  GCC has to be told to pass the -R option through
-        # to the linker, whereas other compilers just know this.
-        # Other compilers may need something slightly different.  At
-        # this time, there's no way to determine this information from
-        # the configuration data stored in the Python installation, so
-        # we use this hack.
-        compiler = os.path.basename(sysconfig.get_config_var("CC"))
-        if compiler == "gcc" or compiler == "g++":
-            return "-Wl,-R" + dir
-        else:
-            return "-R" + dir
+        return "-L" + dir
 
     def library_option (self, lib):
         return "-l" + lib
