--- libmpeg2/cpu_accel.c	2003-10-06 04:31:52.000000000 +0200
+++ libmpeg2/cpu_accel.c	2005-11-24 21:49:47.000000000 +0100
@@ -127,7 +127,7 @@
 }
 
 #ifdef ARCH_PPC
-static inline uint32_t arch_accel (void)
+static uint32_t arch_accel (void)
 {
     static RETSIGTYPE (* oldsig) (int);
 
