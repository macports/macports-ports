--- libavcodec/ppc/dsputil_ppc.h.orig	2005-04-16 14:41:13.000000000 -0600
+++ libavcodec/ppc/dsputil_ppc.h	2005-06-10 01:30:23.000000000 -0600
@@ -22,9 +22,9 @@
 #ifdef CONFIG_DARWIN
 /* The Apple assembler shipped w/ gcc-3.3 knows about DCBZL, previous assemblers don't
    We assume here that the Darwin GCC is from Apple.... */
-#if (__GNUC__ * 100 + __GNUC_MINOR__ < 303)
+/*#if (__GNUC__ * 100 + __GNUC_MINOR__ < 303)*/
 #define NO_DCBZL
-#endif
+/*#endif*/
 #else /* CONFIG_DARWIN */
 /* I don't think any non-Apple assembler knows about DCBZL */
 #define NO_DCBZL
