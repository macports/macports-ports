--- /System/Library/Frameworks/CoreServices.framework/Frameworks/CarbonCore.framework/Headers/fp.h	2007-08-10 22:41:45.000000000 -0700
+++ fp.h	2007-08-16 11:35:47.000000000 -0700
@@ -1314,7 +1314,7 @@
 *   dec2l       Similar to dec2num except a long is returned.                   *
 *                                                                               *
 ********************************************************************************/
-#if TARGET_CPU_PPC || TARGET_CPU_X86 || TARGET_CPU_PPC64 || TARGET_CPU_X86_64
+#if TARGET_CPU_PPC || TARGET_CPU_X86 || TARGET_CPU_PPC64 || TARGET_CPU_X86_64 || TARGET_CPU_ARM
     #define SIGDIGLEN      36  
 #endif
 #define      DECSTROUTLEN   80               /* max length for dec2str output */
