--- setup.py.orig	Fri Dec 13 06:06:28 2002
+++ setup.py	Fri Dec 13 06:09:38 2002
@@ -30,7 +30,7 @@
 # on Windows, the following is used to control how and where to search
 # for Tcl/Tk files.  None enables automatic searching; to override, set
 # this to a directory name.
-TCLROOT = None
+TCLROOT = "@prefix@"
 
 from PIL.Image import VERSION
 
@@ -46,10 +46,10 @@
 LIBRARIES = ["Imaging"]
 
 # Add some standard search spots for MacOSX/darwin
-if os.path.exists('/sw/include'):
-    INCLUDE_DIRS.append('/sw/include')
-if os.path.exists('/sw/lib'):
-    LIBRARY_DIRS.append('/sw/lib')
+if os.path.exists('@prefix@/include'):
+    INCLUDE_DIRS.append('@prefix@/include')
+if os.path.exists('@prefix@/lib'):
+    LIBRARY_DIRS.append('@prefix@/lib')
 
 HAVE_LIBJPEG = 0
 HAVE_LIBTIFF = 0
@@ -63,6 +63,8 @@
         lib = m.group(1)
         if lib == "JPEG":
             HAVE_LIBJPEG = 1
+            INCLUDE_DIRS.append("@prefix@/include")
+            LIBRARY_DIRS.append("@prefix@/lib")
             if sys.platform == "win32":
                 LIBRARIES.append("jpeg")
                 INCLUDE_DIRS.append(JPEGDIR)
@@ -71,6 +73,8 @@
                 LIBRARIES.append("jpeg")
         elif lib == "TIFF":
             HAVE_LIBTIFF = 1
+            INCLUDE_DIRS.append("@prefix@/include")
+            LIBRARY_DIRS.append("@prefix@/lib")
             LIBRARIES.append("tiff")
         elif lib == "Z":
             HAVE_LIBZ = 1
@@ -204,10 +208,15 @@
                 EXTRA_LINK_ARGS = frameworks
                 HAVE_TCLTK = 1
 
+        tk_framework_found = 0
         if not tk_framework_found:
             # assume the libraries are installed in the default location
             LIBRARIES.extend(["tk" + TCL_VERSION, "tcl" + TCL_VERSION])
             HAVE_TCLTK = 1
+            INCLUDE_DIRS.append(os.path.join(TCLROOT, "include"))
+            LIBRARY_DIRS.append(os.path.join(TCLROOT, "lib"))
+            INCLUDE_DIRS.append("/usr/X11R6/include")
+            LIBRARY_DIRS.append("/usr/X11R6/lib")
 
     if HAVE_TCLTK:
         MODULES.append(
@@ -266,13 +275,13 @@
         # FIXME: search for libraries
         LIBRARIES.append("freetype")
         INCLUDE_DIRS.append("/usr/include/freetype2")
-    elif os.path.isdir("/sw/include/freetype2"):
+    elif os.path.isdir("@prefix@/include/freetype2"):
         # assume that the freetype library is installed in a
         # standard location
         # FIXME: search for libraries
         LIBRARIES.append("freetype")
-        INCLUDE_DIRS.append("/sw/include/freetype2")
-        LIBRARY_DIRS.append("/sw/lib")
+        INCLUDE_DIRS.append("@prefix@/include/freetype2")
+        LIBRARY_DIRS.append("@prefix@/lib")
     else:
         have_freetype = 0
 
