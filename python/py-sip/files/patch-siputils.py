--- siputils.py.orig	Sat May 22 11:47:59 2004
+++ siputils.py	Mon May 31 17:56:58 2004
@@ -947,8 +947,8 @@
 
         self.LFLAGS.extend(self.optional_list(lflags_console))
 
-        if sys.platform == "darwin":
-            self.LFLAGS.append("-framework Python")
+#        if sys.platform == "darwin":
+#            self.LFLAGS.append("-framework Python")
 
         Makefile.finalise(self)
 
