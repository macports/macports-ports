--- numpy/distutils/fcompiler/gnu.py.old	2006-09-02 13:00:19.000000000 -0700
+++ numpy/distutils/fcompiler/gnu.py	2006-09-02 13:00:51.000000000 -0700
@@ -245,7 +245,7 @@
     # OS X: GNU Fortran 95 (GCC) 4.1.0
     #       GNU Fortran 95 (GCC) 4.2.0 20060218 (experimental)
 
-    for fc_exe in map(find_executable,['gfortran','f95']):
+    for fc_exe in map(find_executable,['gfortran-dp-4.1','f95']):
         if os.path.isfile(fc_exe):
             break
     executables = {
