--- source/png_pov.cpp.orig	2004-08-03 00:11:37.000000000 +0100
+++ source/png_pov.cpp	2006-11-15 16:48:33.000000000 +0000
@@ -782,7 +782,7 @@
       {
          // finished prematurely - trick into thinking done
          png_ptr->num_rows = png_ptr->row_number;
-         png_write_finish_row(png_ptr);
+         png_write_row(png_ptr, row_ptr);
       }
 
 #ifdef POV_COMMENTS // temporarily skip comment writing code 
