--- src/ref.c.orig	Tue Feb 13 16:38:06 2001
+++ src/ref.c	Thu Feb 19 16:26:17 2004
@@ -263,7 +263,7 @@
 read_new_value (CELLREF row, CELLREF col, char *form, char *val)
 {
   unsigned char *new_bytes;
-  extern double __plinf, __neinf, __nan;
+  extern double __plinf, __neinf, __o_nan;
 
   cur_row = row;
   cur_col = col;
@@ -348,7 +348,7 @@
 	  else if (!stricmp (nname, val))
 	    {
 	      SET_TYP (my_cell, TYP_FLT);
-	      my_cell->cell_flt = __nan;
+	      my_cell->cell_flt = __o_nan;
 	    }
 	  else
 	    {
