--- scipy_core/scipy_distutils/gnufcompiler.py	Wed Feb 18 01:51:39 2004
+++ scipy_core/scipy_distutils/gnufcompiler.py	Thu Mar  4 06:28:32 2004
@@ -27,7 +27,7 @@
         'compiler_f77' : [fc_exe,"-Wall","-fno-second-underscore"],
         'compiler_f90' : None,
         'compiler_fix' : None,
-        'linker_so'    : [fc_exe],
+        'linker_so'    : ['gcc -bundle -flat_namespace -undefined suppress'],
         'archiver'     : ["ar", "-cr"],
         'ranlib'       : ["ranlib"],
         }
@@ -52,7 +52,7 @@
                 # This is when Python is from Apple framework
                 opt.extend(["-Wl,-framework","-Wl,Python"])
             #else we are running in Fink python.
-            opt.extend(["-lcc_dynamic","-bundle"])
+#           opt.extend(["-lcc_dynamic","-bundle"])
         else:
             opt.append("-shared")
         if sys.platform[:5]=='sunos':
@@ -94,6 +94,7 @@
             opt.extend(['gcc',g2c])
         else:
             opt.append(g2c)
+        opt.append('cc_dynamic')
         return opt
 
     def get_flags_debug(self):
