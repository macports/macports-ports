--- crypt/osconfig.h.orig	2010-12-19 04:14:06.000000000 -0600
+++ crypt/osconfig.h	2011-04-27 07:05:00.000000000 -0500
@@ -257,6 +257,10 @@
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
