--- /Users/roederja/Desktop/setup.py.orig	2007-05-20 13:02:39.000000000 -0700
+++ setup.py	2007-05-20 14:49:50.000000000 -0700
@@ -246,11 +246,11 @@
         # Add paths to popular package managers on OS X/darwin
         if sys.platform == "darwin":
             # Fink installs into /sw by default
-            add_dir_to_list(self.compiler.library_dirs, '/sw/lib')
-            add_dir_to_list(self.compiler.include_dirs, '/sw/include')
+            #add_dir_to_list(self.compiler.library_dirs, '/sw/lib')
+            #add_dir_to_list(self.compiler.include_dirs, '/sw/include')
             # DarwinPorts installs into /opt/local by default
-            #add_dir_to_list(self.compiler.library_dirs, '/opt/local/lib')
-            #add_dir_to_list(self.compiler.include_dirs, '/opt/local/include')
+            add_dir_to_list(self.compiler.library_dirs, '__PREFIX__/lib')
+            add_dir_to_list(self.compiler.include_dirs, '__PREFIX__/include')
 
         if os.path.normpath(sys.prefix) != '/usr':
             add_dir_to_list(self.compiler.library_dirs,
@@ -357,7 +357,7 @@
             exts.append( Extension('unicodedata', ['unicodedata.c']) )
         # access to ISO C locale support
         data = open('pyconfig.h').read()
-        m = re.search(r"#s*define\s+WITH_LIBINTL\s+1\s*", data)
+        m = re.search(r"#\s*define\s+(HAVE_LIBINTL_H|WITH_LIBINTL)\s+1\s*", data)
         if m is not None:
             locale_libs = ['intl']
         else:
@@ -954,7 +954,8 @@
         self.extensions.extend(exts)
 
         # Call the method for detecting whether _tkinter can be compiled
-        self.detect_tkinter(inc_dirs, lib_dirs)
+        if ("--disable-tk" not in sysconfig.get_config_var("CONFIG_ARGS")):
+            self.detect_tkinter(inc_dirs, lib_dirs)
 
     def detect_tkinter_darwin(self, inc_dirs, lib_dirs):
         # The _tkinter module, using frameworks. Since frameworks are quite
