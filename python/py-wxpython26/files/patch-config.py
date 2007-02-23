--- config.py	2005-06-04 18:23:06.000000000 +0200
+++ config.py	2005-07-08 16:51:30.000000000 +0200
@@ -107,7 +107,7 @@
                    # cause the two strings to be combined and output
                    # as the full docstring.
 
-UNICODE = 0        # This will pass the 'wxUSE_UNICODE' flag to SWIG and
+UNICODE = 1        # This will pass the 'wxUSE_UNICODE' flag to SWIG and
                    # will ensure that the right headers are found and the
                    # right libs are linked.
 
@@ -762,7 +762,7 @@
         cflags.append('-g')
         cflags.append('-O0')
     else:
-        cflags.append('-O3')
+        cflags.append('-O2')
 
     lflags = os.popen(WX_CONFIG + ' --libs', 'r').read()[:-1]
     lflags = lflags.split()
