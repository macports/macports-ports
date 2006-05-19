--- src/builtin.c	2005/09/16 16:03:46	1.91
+++ src/builtin.c	2006/05/19 21:20:51	1.92
@@ -7,8 +7,8 @@
  * the license in the file "License", which is included in the distribution.
  *
  * $RCSfile: patch-builtin.c,v $
- * $Revision: 1.1 $
- * $Date: 2006/05/19 23:50:17 $
+ * $Revision: 1.1 $
+ * $Date: 2006/05/19 23:50:17 $
  * ------------------------------------------------------------------------*/
 
 /* We include math.h before prelude.h because SunOS 4's cpp incorrectly
@@ -1988,6 +1988,7 @@ static struct thunk_data* foreignThunks 
    to return to it before tail jumping from the adjustor thunk.
 */
 static unsigned char *obscure_ccall_ret_code;	/* set by initAdjustor() */
+#endif /* i386_HOST_ARCH */
 
 /* Heavily arch-specific, I'm afraid.. */
 
@@ -2024,8 +2025,6 @@ static void* local mallocBytesRWX(int le
     return addr;
 }
 
-#endif /* i386_HOST_ARCH */
-
 /* Perform initialisation of adjustor thunk layer (if needed). */
 static void local initAdjustor() {
 #if i386_HOST_ARCH
