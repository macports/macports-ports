--- gcc/config/i386/darwin.h.orig	2007-02-21 09:08:33.000000000 -0800
+++ gcc/config/i386/darwin.h	2007-02-21 09:10:03.000000000 -0800
@@ -106,6 +106,8 @@
 #define ASM_LONG "\t.long\t"
 /* Darwin as doesn't do ".quad".  */
 
+#define SUBTARGET_ENCODE_SECTION_INFO  darwin_encode_section_info
+
 #undef ASM_OUTPUT_ALIGN
 #define ASM_OUTPUT_ALIGN(FILE,LOG)	\
  do { if ((LOG) != 0)			\
