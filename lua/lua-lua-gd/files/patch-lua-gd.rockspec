--- lua-gd-1.0-6.rockspec.orig	1979-12-31 00:00:00
+++ lua-gd-1.0-6.rockspec	2023-03-18 09:24:12
@@ -12,4 +12,12 @@
 dependencies = {}
 build = {
     type = "make",
+    build_variables = {
+        LUA_INCDIR = '$(LUA_INCDIR)',
+        LUA_LIBDIR = '$(LUA_LIBDIR)',
+        LIBFLAG = '$(LIBFLAG)',
+    },
+    install_variables = {
+        LIBDIR = '$(LIBDIR)'
+    }
 }
\ No newline at end of file
