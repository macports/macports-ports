--- aes.c	Thu Jan 24 15:02:24 2002
+++ ../aes-rb-0.1.0-patched/aes.c	Sat Dec 18 22:11:50 2004
@@ -84,7 +84,7 @@
 ***************/
 static void
 aes_dealloc(AesObject *rijnp) {
-  PyMem_DEL(rijnp);  /* add it back to the free object list. */
+  free(rijnp);
 }
 
 /***************
