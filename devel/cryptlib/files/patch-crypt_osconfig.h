--- crypt/osconfig.h.orig	2009-05-07 02:07:36.000000000 +1000
+++ crypt/osconfig.h	2009-09-22 05:53:36.000000000 +1000
@@ -231,6 +231,10 @@
   #else
 	#define L_ENDIAN
   #endif
+  #if defined( __LP64__ )
+    #undef SIXTY_FOUR_BIT
+    #define SIXTY_FOUR_BIT_LONG
+  #endif
   #define BN_LLONG
   #define BF_PTR
   #define DES_RISC1
