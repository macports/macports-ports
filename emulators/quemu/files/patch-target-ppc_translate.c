diff -urN target-ppc/translate.c qemu-0.6.0-2/target-ppc/translate.c
--- target-ppc/translate.c	Sat Jul 10 20:20:09 2004
+++ qemu-0.6.0-2/target-ppc/translate.c	Thu Jul 15 15:08:07 2004
@@ -276,11 +276,12 @@
     return ret;
 }
 
-#if defined(__linux__)
+#if defined(__APPLE__)
 #define OPCODES_SECTION \
-    __attribute__ ((section(".opcodes"), unused, aligned (8) ))
+    __attribute__ ((section("__TEXT,__opcodes"), unused, aligned (8) ))
 #else
-#define OPCODES_SECTION
+#define OPCODES_SECTION \
+   __attribute__ ((section(".opcodes"), unused, aligned (8) ))
 #endif
 
 #define GEN_OPCODE(name, op1, op2, op3, invl, _typ)                           \

