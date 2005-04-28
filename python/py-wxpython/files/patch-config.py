--- config.py	Tue Apr 26 17:15:40 2005
+++ config.py.new	Thu Apr 28 21:39:24 2005
@@ -107,7 +107,7 @@
                    # cause the two strings to be combined and output
                    # as the full docstring.
 
-UNICODE = 0        # This will pass the 'wxUSE_UNICODE' flag to SWIG and
+UNICODE = 1        # This will pass the 'wxUSE_UNICODE' flag to SWIG and
                    # will ensure that the right headers are found and the
                    # right libs are linked.
 
@@ -760,7 +760,7 @@
         cflags.append('-g')
         cflags.append('-O0')
     else:
-        cflags.append('-O3')
+        cflags.append('-O2')
 
     lflags = os.popen(WX_CONFIG + ' --libs', 'r').read()[:-1]
     lflags = lflags.split()
