--- gdb/remote.c~	2008-02-25 10:59:06.000000000 +0100
+++ gdb/remote.c	2010-01-19 11:30:19.000000000 +0100
@@ -6102,8 +6102,9 @@
 				     [PACKET_qXfer_spu_write]);
     }
 
-  /* Only handle flash writes.  */
-  if (writebuf != NULL)
+  /* Only handle flash writes.  Zero OFFSET and LENGTH is just a size
+   * query only, so proceed anyway. */
+  if (writebuf != NULL && !(offset == 0 && len == 0))
     {
       LONGEST xfered;
 
