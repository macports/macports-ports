--- faad2/libfaad/common.h	2004-09-08 05:43:12.000000000 -0400
+++ faad2/libfaad/common.h	2006-10-19 18:16:44.000000000 -0400
@@ -288,7 +288,7 @@
       *y2 = MUL_F(x2, c1) - MUL_F(x1, c2);
   }
 
-
+#ifndef HAS_LRINTF
   #if defined(_WIN32) && !defined(__MINGW32__)
     #define HAS_LRINTF
     static INLINE int lrintf(float f)
@@ -315,7 +315,7 @@
         return i;
     }
   #endif
-
+#endif
 
   #ifdef __ICL /* only Intel C compiler has fmath ??? */
 
