--- contrib/infback9/infback9.c	Sun Sep 14 08:49:53 2003
+++ contrib/infback9/infback9.c	Wed Sep  1 14:33:21 2004
@@ -430,6 +430,9 @@
                 }
             }
 
+            /* handle error breaks in while */
+            if (mode == BAD) break;
+
             /* build code tables */
             state->next = state->codes;
             lencode = (code const FAR *)(state->next);
