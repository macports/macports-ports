--- setupext.py.orig	2021-05-09 11:35:25.000000000 -0400
+++ setupext.py	2021-05-09 11:35:29.000000000 -0400
@@ -381,6 +381,7 @@
                 "src/_backend_agg_wrapper.cpp",
             ])
         add_numpy_flags(ext)
+        add_macports_flags(ext)
         add_libagg_flags_and_sources(ext)
         FreeType.add_flags(ext)
         yield ext
@@ -391,6 +392,7 @@
                 "linux": ["dl"],
                 "win32": ["ole32", "shell32", "user32"],
             }.get(sys.platform, [])))
+        add_macports_flags(ext)
         yield ext
         # contour
         ext = Extension(
@@ -400,6 +402,7 @@
                 "src/py_converters.cpp",
             ])
         add_numpy_flags(ext)
+        add_macports_flags(ext)
         add_libagg_flags(ext)
         yield ext
         # ft2font
@@ -412,6 +415,7 @@
             ])
         FreeType.add_flags(ext)
         add_numpy_flags(ext)
+        add_macports_flags(ext)
         add_libagg_flags(ext)
         yield ext
         # image
@@ -423,6 +427,7 @@
                 "src/py_converters.cpp",
             ])
         add_numpy_flags(ext)
+        add_macports_flags(ext)
         add_libagg_flags_and_sources(ext)
         yield ext
         # path
@@ -432,6 +437,7 @@
                 "src/_path_wrapper.cpp",
             ])
         add_numpy_flags(ext)
+        add_macports_flags(ext)
         add_libagg_flags_and_sources(ext)
         yield ext
         # qhull
@@ -439,6 +445,7 @@
             "matplotlib._qhull", ["src/qhull_wrap.c"],
             define_macros=[("MPL_DEVNULL", os.devnull)])
         add_numpy_flags(ext)
+        add_macports_flags(ext)
         Qhull.add_flags(ext)
         yield ext
         # tkagg
@@ -452,6 +459,7 @@
                         "cygwin": ["psapi"]}.get(sys.platform, [])),
             extra_link_args={"win32": ["-mwindows"]}.get(sys.platform, []))
         add_numpy_flags(ext)
+        add_macports_flags(ext)
         add_libagg_flags(ext)
         yield ext
         # tri
@@ -462,6 +470,7 @@
                 "src/mplutils.cpp",
             ])
         add_numpy_flags(ext)
+        add_macports_flags(ext)
         yield ext
         # ttconv
         ext = Extension(
@@ -473,9 +482,11 @@
             ],
             include_dirs=["extern"])
         add_numpy_flags(ext)
+        add_macports_flags(ext)
         yield ext
 
 
+
 class Tests(OptionalPackage):
     name = "tests"
     default_config = False
@@ -494,6 +505,11 @@
         }
 
 
+def add_macports_flags(ext):
+    mp_cxxflags = os.getenv('CXXFLAGS').split()
+    print(f"MacPorts CXXFLAGS = {mp_cxxflags}")
+    ext.extra_compile_args.extend(mp_cxxflags)
+
 def add_numpy_flags(ext):
     import numpy as np
     ext.include_dirs.append(np.get_include())
@@ -706,4 +722,5 @@
         ext.extra_link_args.extend(['-framework', 'Cocoa'])
         if platform.python_implementation().lower() == 'pypy':
             ext.extra_compile_args.append('-DPYPY=1')
+        add_macports_flags(ext)
         yield ext
