--- setup.py	Thu Dec  2 18:25:36 2004
+++ setup.py.new	Thu Mar 31 17:08:03 2005
@@ -18,11 +18,8 @@
     extra_objects = []
 elif sys.platform in ("freebsd4", "freebsd5", "openbsd2", "cygwin", "darwin"):
     if sys.platform == "darwin":
-        LOCALBASE = os.environ.get("LOCALBASE", "/opt/local")
-    else:
-        LOCALBASE = os.environ.get("LOCALBASE", "/usr/local")
-    include_dirs = ['%s/include' % LOCALBASE]
-    library_dirs = ['%s/lib/' % LOCALBASE]
+        include_dirs = ['/Library/Frameworks/SQLite3.framework/Versions/Current/Headers']
+        library_dirs = ['/Library/Frameworks/SQLite3.framework/Versions/Current/Libraries']
     libraries = [sqlite]
     runtime_library_dirs = []
     extra_objects = []
