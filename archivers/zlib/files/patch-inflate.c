--- inflate.c	Sat Oct 25 23:15:36 2003
+++ inflate.c	Wed Sep  1 14:25:15 2004
@@ -861,6 +861,9 @@
                 }
             }
 
+            /* handle error breaks in while */
+            if (state->mode == BAD) break;
+
             /* build code tables */
             state->next = state->codes;
             state->lencode = (code const FAR *)(state->next);
