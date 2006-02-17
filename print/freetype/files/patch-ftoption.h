--- include/freetype/config/ftoption.h.orig	2005-06-06 08:37:53.000000000 -0700
+++ include/freetype/config/ftoption.h	2006-02-15 21:57:57.000000000 -0800
@@ -436,7 +436,7 @@
   /*   Do not #undef this macro here, since the build system might         */
   /*   define it for certain configurations only.                          */
   /*                                                                       */
-/* #define TT_CONFIG_OPTION_BYTECODE_INTERPRETER */
+#define TT_CONFIG_OPTION_BYTECODE_INTERPRETER
 
 
   /*************************************************************************/
