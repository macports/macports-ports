--- include/cln/modules.h.sav	Wed Aug 25 21:28:21 2004
+++ include/cln/modules.h	Wed Aug 25 21:32:34 2004
@@ -85,7 +85,7 @@
     #define CL_GLOBALIZE_LABEL(label)
   #endif
   #if defined(__rs6000__) || defined(_WIN32)
-    #define CL_GLOBALIZE_JUMP_LABEL(label)  CL_GLOBALIZE_LABEL(#label)
+    #define CL_GLOBALIZE_JUMP_LABEL(label)  CL_GLOBALIZE_LABEL(ASM_UNDERSCORE_PREFIX #label)
   #else
     #define CL_GLOBALIZE_JUMP_LABEL(label)
   #endif
@@ -121,7 +121,7 @@
     #define CL_JUMP_TO(addr)  ASM_VOLATILE("jmp %*%0" : : "rm" ((void*)(addr)))
   #endif
   #if defined(__x86_64__)
-    #define CL_JUMP_TO(addr)  ASM_VOLATILE("jmp " #addr)
+    #define CL_JUMP_TO(addr)  ASM_VOLATILE("jmp " ASM_UNDERSCORE_PREFIX #addr)
   #endif
   #if defined(__m68k__)
     #define CL_JUMP_TO(addr)  ASM_VOLATILE("jmp %0@" : : "a" ((void*)(addr)))
@@ -137,14 +137,14 @@
   #endif
   #if defined(__hppa__)
     //#define CL_JUMP_TO(addr)  ASM_VOLATILE("bv,n 0(%0)" : : "r" ((void*)(addr)))
-    #define CL_JUMP_TO(addr)  ASM_VOLATILE("b " #addr "\n\tnop")
+    #define CL_JUMP_TO(addr)  ASM_VOLATILE("b " ASM_UNDERSCORE_PREFIX #addr "\n\tnop")
   #endif
   #if defined(__arm__)
     #define CL_JUMP_TO(addr)  ASM_VOLATILE("mov pc,%0" : : "r" ((void*)(addr)))
   #endif
   #if defined(__rs6000__) || defined(__powerpc__) || defined(__ppc__)
     //#define CL_JUMP_TO(addr)  ASM_VOLATILE("mtctr %0\n\tbctr" : : "r" ((void*)(addr)))
-    #define CL_JUMP_TO(addr)  ASM_VOLATILE("b " #addr)
+    #define CL_JUMP_TO(addr)  ASM_VOLATILE("b " ASM_UNDERSCORE_PREFIX #addr)
   #endif
   #if defined(__m88k__)
     #define CL_JUMP_TO(addr)  ASM_VOLATILE("jmp %0" : : "r" ((void*)(addr)))
@@ -153,7 +153,7 @@
     #define CL_JUMP_TO(addr)  ASM_VOLATILE("jmp (%0)" : : "r" ((void*)(addr)))
   #endif
   #if defined(__ia64__)
-    #define CL_JUMP_TO(addr)  ASM_VOLATILE("br " #addr)
+    #define CL_JUMP_TO(addr)  ASM_VOLATILE("br " ASM_UNDERSCORE_PREFIX #addr)
   #endif
   #if defined(__s390__)
     #define CL_JUMP_TO(addr)  ASM_VOLATILE("br %0" : : "a" ((void*)(addr)))
