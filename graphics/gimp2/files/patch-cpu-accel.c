--- app/base/cpu-accel.c.orig	2005-06-18 12:37:55.000000000 -0400
+++ app/base/cpu-accel.c	2005-06-18 13:19:30.000000000 -0400
@@ -361,7 +361,7 @@
 #endif /* ARCH_X86 && USE_MMX && __GNUC__ */
 
 
-#if defined (ARCH_PPC) && defined (USE_ALTIVEC) && defined(__GNUC__)
+#if defined (ARCH_PPC) && defined (USE_ALTIVEC)
 
 #define HAVE_ACCEL 1
 
@@ -395,7 +395,7 @@
   canjump = 1;
 
   asm volatile ("mtspr 256, %0\n\t"
-                "vand %%v0, %%v0, %%v0"
+                "vand v0,v0,v0\n\t"
                 :
                 : "r" (-1));
 
