--- configure.py.orig	2006-03-24 19:09:08.000000000 -0500
+++ configure.py	2006-04-19 06:05:07.000000000 -0400
@@ -253,6 +253,7 @@
             0x030200: "Qt_3_1_2",
             0x030300: "Qt_3_2_0",
             0x030305: "Qt_3_3_0",
+            0x030304: "Qt_3_3_4",
             0x030306: "Qt_3_3_5",
             0x040000: "Qt_3_3_6"
         }
@@ -1026,9 +1027,9 @@
     """
     # Get the name of the qmake configuration file to take the macros from.
     if "QMAKESPEC" in os.environ.keys():
-        fname = os.path.join(qt_dir, "mkspecs", os.environ["QMAKESPEC"], "qmake.conf")
+        fname = "qmake.conf"
     else:
-        fname = os.path.join(qt_dir, "mkspecs", "default", "qmake.conf")
+        fname = "qmake.conf"
 
         if not os.access(fname, os.F_OK):
             sipconfig.error("Unable to find the default configuration file %s. You can use the QMAKESPEC environment variable to specify the correct platform instead of \"default\"." % fname)
