--- siputils.py.org.py	2006-11-04 14:09:43.000000000 -0800
+++ siputils.py	2006-11-06 20:23:11.000000000 -0800
@@ -1302,11 +1302,11 @@
             # This allows Apple's Python to be used even if a later python.org
             # version is also installed.
             dl = string.split(sys.exec_prefix, os.sep)
-            try:
-                dl = dl[:dl.index("Python.framework")]
-            except ValueError:
-                error("SIP requires Python to be built as a framework")
-            self.LFLAGS.append("-F%s" % string.join(dl, os.sep))
+            # try:
+               # dl = dl[:dl.index("Python.framework")]
+            # except ValueError:
+               # error("SIP requires Python to be built as a framework")
+            # self.LFLAGS.append("-F%s" % string.join(dl, os.sep))
             self.LFLAGS.append("-framework Python")
 
         Makefile.finalise(self)
