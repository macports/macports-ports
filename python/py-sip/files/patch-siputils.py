--- siputils.py.orig	2006-08-18 16:36:18.000000000 -0400
+++ siputils.py	2006-08-18 16:52:22.000000000 -0400
@@ -1273,8 +1273,8 @@
             # This allows Apple's Python to be used even if a later python.org
             # version is also installed.
             dl = string.split(sys.exec_prefix, os.sep)
-            dl = dl[:dl.index("Python.framework")]
-            self.LFLAGS.append("-F%s" % string.join(dl, os.sep))
+            #dl = dl[:dl.index("Python.framework")]
+            #self.LFLAGS.append("-F%s" % string.join(dl, os.sep))
             self.LFLAGS.append("-framework Python")
 
         Makefile.finalise(self)
