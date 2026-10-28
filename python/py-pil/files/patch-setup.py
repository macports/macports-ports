--- setup.py.orig	2006-12-03 04:37:29.000000000 -0700
+++ setup.py	2009-09-18 19:58:45.000000000 -0600
@@ -33,12 +33,12 @@
 #
 # TIFF_ROOT = libinclude("/opt/tiff")
 
-TCL_ROOT = None
-JPEG_ROOT = None
-ZLIB_ROOT = None
-TIFF_ROOT = None
-FREETYPE_ROOT = None
-LCMS_ROOT = None
+TCL_ROOT = "__PREFIX__/lib", "__PREFIX__/include"
+JPEG_ROOT = "__PREFIX__/lib", "__PREFIX__/include"
+ZLIB_ROOT = "__PREFIX__/lib", "__PREFIX__/include"
+TIFF_ROOT = "__PREFIX__/lib", "__PREFIX__/include"
+FREETYPE_ROOT = "__PREFIX__/lib/", "__PREFIX__/include/freetype2/"
+LCMS_ROOT = "__PREFIX__/lib", "__PREFIX__/include"
 
 # FIXME: add mechanism to explicitly *disable* the use of a library
 
@@ -331,30 +331,7 @@
                 "_imagingcms", ["_imagingcms.c"], libraries=["lcms"] + extra
                 ))
 
-        if sys.platform == "darwin":
-            # locate Tcl/Tk frameworks
-            frameworks = []
-            framework_roots = [
-                "/Library/Frameworks",
-                "/System/Library/Frameworks"
-                ]
-            for root in framework_roots:
-                if (os.path.exists(os.path.join(root, "Tcl.framework")) and
-                    os.path.exists(os.path.join(root, "Tk.framework"))):
-                    print "--- using frameworks at", root
-                    frameworks = ["-framework", "Tcl", "-framework", "Tk"]
-                    dir = os.path.join(root, "Tcl.framework", "Headers")
-                    add_directory(self.compiler.include_dirs, dir, 0)
-                    dir = os.path.join(root, "Tk.framework", "Headers")
-                    add_directory(self.compiler.include_dirs, dir, 1)
-                    break
-            if frameworks:
-                exts.append(Extension(
-                    "_imagingtk", ["_imagingtk.c", "Tk/tkImaging.c"],
-                    extra_compile_args=frameworks, extra_link_args=frameworks
-                    ))
-                feature.tcl = feature.tk = 1 # mark as present
-        elif feature.tcl and feature.tk:
+        if feature.tcl and feature.tk:
             exts.append(Extension(
                 "_imagingtk", ["_imagingtk.c", "Tk/tkImaging.c"],
                 libraries=[feature.tcl, feature.tk]
