--- infback.c	Mon Aug 11 16:48:06 2003
+++ infback.c	Wed Sep  1 14:31:36 2004
@@ -434,6 +434,9 @@
                 }
             }
 
+            /* handle error breaks in while */
+            if (state->mode == BAD) break;
+
             /* build code tables */
             state->next = state->codes;
             state->lencode = (code const FAR *)(state->next);
