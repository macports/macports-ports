--- crypt/osconfig.h.orig	2011-06-17 22:20:36.000000000 -0500
+++ crypt/osconfig.h	2011-10-16 23:51:19.000000000 -0500
@@ -259,6 +259,10 @@
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
