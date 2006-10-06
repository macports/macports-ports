--- libfaad/common.h	2006-08-08 03:13:28.000000000 +0900
+++ libfaad/common.h	2006-10-07 07:55:17.000000000 +0900
@@ -309,6 +309,7 @@
   }
 
 
+#ifndef HAS_LRINTF
   #if defined(_WIN32) && !defined(__MINGW32__)
     #define HAS_LRINTF
     static INLINE int lrintf(float f)
@@ -336,7 +337,7 @@
         return i;
     }
   #endif
-
+#endif
 
   #ifdef __ICL /* only Intel C compiler has fmath ??? */
 
