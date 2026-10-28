--- gcc/config/darwin.h	(revision 41769)
+++ gcc/config/darwin.h	(working copy)
@@ -957,15 +957,15 @@
   } while (0)
 
 /* APPLE LOCAL begin mainline */
-#undef  ASM_OUTPUT_ALIGNED_COMMON
-#define ASM_OUTPUT_ALIGNED_COMMON(FILE, NAME, SIZE, ALIGN)		\
+#undef  ASM_OUTPUT_COMMON
+#define ASM_OUTPUT_COMMON(FILE, NAME, SIZE, ALIGN)			\
   do {									\
     unsigned HOST_WIDE_INT _new_size = (SIZE);				\
     fprintf ((FILE), ".comm ");						\
     assemble_name ((FILE), (NAME));					\
     if (_new_size == 0) _new_size = 1;					\
-    fprintf ((FILE), ","HOST_WIDE_INT_PRINT_UNSIGNED",%u\n",		\
-	     _new_size, floor_log2 ((ALIGN) / BITS_PER_UNIT));		\
+    fprintf ((FILE), ","HOST_WIDE_INT_PRINT_UNSIGNED"\n",		\
+	     _new_size);						\
   } while (0)
 
 /* The maximum alignment which the object file format can support in
