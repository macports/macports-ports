--- include/freetype/config/ftoption.h.orig 2008-11-05 03:25:14.000000000 -0600
+++ include/freetype/config/ftoption.h 2009-01-18 03:35:45.000000000 -0600
@@ -480,7 +480,7 @@
   /*   Do not #undef this macro here, since the build system might         */
   /*   define it for certain configurations only.                          */
   /*                                                                       */
-/* #define TT_CONFIG_OPTION_BYTECODE_INTERPRETER */
+#define TT_CONFIG_OPTION_BYTECODE_INTERPRETER
 
 
   /*************************************************************************/
