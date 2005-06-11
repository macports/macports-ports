--- libmpeg2/cpu_state.c.orig	2005-02-18 19:32:12.000000000 -0700
+++ libmpeg2/cpu_state.c	2005-06-10 02:04:23.000000000 -0600
@@ -48,7 +48,7 @@
 #endif
 
 #if defined( ARCH_PPC ) && defined( HAVE_ALTIVEC )
-#ifdef HAVE_ALTIVEC_H	/* gnu */
+#if defined( HAVE_ALTIVEC_H ) && !defined( SYS_DARWIN )   /* gnu */
 #define LI(a,b) "li " #a "," #b "\n\t"
 #define STVX0(a,b,c) "stvx " #a ",0," #c "\n\t"
 #define STVX(a,b,c) "stvx " #a "," #b "," #c "\n\t"
