--- octave-2.9.9.orig/scripts/optimization/glpk.m	2007-02-26 13:30:39.000000000 -0800
+++ octave-2.9.9/scripts/optimization/glpk.m	2007-02-26 13:32:37.000000000 -0800
@@ -361,7 +361,8 @@
 ## @item time
 ## Time (in seconds) used for solving LP/MIP problem.
 ## @item mem
-## Memory (in bytes) used for solving LP/MIP problem.
+## Memory (in bytes) used for solving LP/MIP problem (this is not 
+## available if the version of GLPK is 4.15 or later)
 ## @end table
 ## @end table
 ## 
