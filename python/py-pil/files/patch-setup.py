--- setup.py.orig	Mon Feb 14 12:49:53 2005
+++ setup.py	Mon Feb 14 15:34:12 2005
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
@@ -119,10 +123,17 @@
 # --------------------------------------------------------------------
 # configure imagingtk module
 
+EXTRA_COMPILE_ARGS = None
+EXTRA_LINK_ARGS = None
+
 try:
     import _tkinter
     TCL_VERSION = _tkinter.TCL_VERSION[:3]
 except (ImportError, AttributeError):
+    if (os.getenv('WITH_TK') == "yes"):
+        print "*** Python",sys.version[0]+"."+sys.version[2],"was not built with Tk support!"
+        print "*** _imagingtk extension can not be built!"
+        sys.exit(1)
     pass
 else:
     INCLUDE_DIRS = ["libImaging"]
@@ -204,10 +215,18 @@
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
+
+    if (os.getenv('WITH_TK') != "yes") and HAVE_TCLTK:
+        HAVE_TCLTK = 0
 
     if HAVE_TCLTK:
         MODULES.append(
@@ -220,6 +239,16 @@
                 )
             )
 
+if (os.getenv('WITH_TK') == "yes") and not HAVE_TCLTK:
+    print "*** Unable to locate required Tk installation!"
+    print "*** _imagingtk extension can not be built!"
+    sys.exit(1)
+
+if HAVE_TCLTK:
+    print "*** Tk enabled."
+else:
+    print "*** Tk disabled."
+
 # --------------------------------------------------------------------
 # configure imagingft module
 
@@ -266,13 +295,20 @@
         # FIXME: search for libraries
         LIBRARIES.append("freetype")
         INCLUDE_DIRS.append("/usr/include/freetype2")
-    elif os.path.isdir("/sw/include/freetype2"):
+    elif os.path.isdir("/usr/X11R6/include/freetype2"):
+        # assume that the freetype library is installed in a
+        # standard location
+        # FIXME: search for libraries
+        LIBRARIES.append("freetype")
+        INCLUDE_DIRS.append("/usr/X11R6/include/freetype2")
+        LIBRARY_DIRS.append("/usr/X11R6/lib")
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
 
