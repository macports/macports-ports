--- setup.py	Fri Oct 22 01:32:09 2004
+++ setup.py.new	Tue Nov 16 16:44:00 2004
@@ -40,15 +40,20 @@
              ]
 # set these to use your own BLAS;
 
-library_dirs_list = ['/usr/lib/atlas']
-libraries_list = ['lapack', 'cblas', 'f77blas', 'atlas', 'g2c'] 
+library_dirs_list = []
+libraries_list = []
                    # if you also set `use_dotblas` (see below), you'll need:
                    # ['lapack', 'cblas', 'f77blas', 'atlas', 'g2c']
 
 # set to true (1), if you also want BLAS optimized matrixmultiply/dot/innerproduct
 use_dotblas = 1
-include_dirs = ['/usr/include/atlas']  # You may need to set this to find cblas.h
-                   #  e.g. on UNIX using ATLAS this should be ['/usr/include/atlas'] 
+VECLIB_PATH = '/System/Library/Frameworks/vecLib.framework'
+if os.path.exists(VECLIB_PATH):
+    extra_link_args = ['-framework', 'vecLib']
+    include_dirs = [os.path.join(VECLIB_PATH, 'Headers')]
+else:
+    extra_link_args = []
+    include_dirs = ['__PREFIX__/include/atlas']
 
 # The packages are split in this way to allow future optional inclusion
 # Numeric package
@@ -82,7 +87,8 @@
     Extension('lapack_lite', sourcelist,
               library_dirs = library_dirs_list,
               libraries = libraries_list,
-              extra_compile_args = extra_compile_args) 
+              extra_link_args = extra_link_args,
+              extra_compile_args = extra_compile_args)
     ]
 
 # add FFT package (optional)
@@ -115,6 +121,7 @@
                                  [os.path.join('Packages', 'dotblas', 'dotblas', '_dotblas.c')],
                                  library_dirs = library_dirs_list,
                                  libraries = libraries_list,
+                                 extra_link_args = extra_link_args,
                                  extra_compile_args=extra_compile_args))
 
 
