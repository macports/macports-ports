--- numpy/distutils/fcompiler/gnu.py.old	2006-01-29 02:10:27.000000000 -0800
+++ numpy/distutils/fcompiler/gnu.py	2006-01-29 02:10:59.000000000 -0800
@@ -107,8 +107,8 @@
             opt.append('gcc')
         if g2c is not None:
             opt.append(g2c)
-        if sys.platform == 'darwin':
-            opt.append('cc_dynamic')
+        #if sys.platform == 'darwin':
+        #    opt.append('cc_dynamic')
         return opt
 
     def get_flags_debug(self):
@@ -216,7 +216,7 @@
     # 'gfortran --version' results:
     # Debian: GNU Fortran 95 (GCC 4.0.3 20051023 (prerelease) (Debian 4.0.2-3))
 
-    for fc_exe in map(find_executable,['gfortran','f95']):
+    for fc_exe in map(find_executable,['gfortran-dp-4.0','f95']):
         if os.path.isfile(fc_exe):
             break
     executables = {
