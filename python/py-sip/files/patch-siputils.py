--- siputils.py	Fri Sep 24 18:56:34 2004
+++ siputils.py.new	Mon Sep 27 13:34:52 2004
@@ -994,8 +994,8 @@
 
         self.LFLAGS.extend(self.optional_list(lflags_console))
 
-        if sys.platform == "darwin":
-            self.LFLAGS.append("-framework Python")
+#        if sys.platform == "darwin":
+#            self.LFLAGS.append("-framework Python")
 
         Makefile.finalise(self)
 
