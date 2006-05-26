--- src/builtin.c.orig	2005-09-16 12:03:46.000000000 -0400
+++ src/builtin.c	2006-05-25 21:33:22.000000000 -0400
@@ -1988,6 +1988,7 @@
    to return to it before tail jumping from the adjustor thunk.
 */
 static unsigned char *obscure_ccall_ret_code;	/* set by initAdjustor() */
+#endif /* i386_HOST_ARCH */
 
 /* Heavily arch-specific, I'm afraid.. */
 
@@ -2024,8 +2025,6 @@
     return addr;
 }
 
-#endif /* i386_HOST_ARCH */
-
 /* Perform initialisation of adjustor thunk layer (if needed). */
 static void local initAdjustor() {
 #if i386_HOST_ARCH
