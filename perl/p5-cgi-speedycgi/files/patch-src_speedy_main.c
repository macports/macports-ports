--- src/speedy_main.c	2005/08/31 19:56:57	1.1
+++ src/speedy_main.c	2005/08/31 19:57:42
@@ -299,6 +299,7 @@
     /* Copy streams */
     while (1) {
 	/* Do reads/writes */
+        int close_stdout_delayed = 0;
 	for (i = 0; i < NUMFDS; ++i) {
 	    register CopyBuf *b = cb + i;
 	    int do_read  = my_canread(b) &&
@@ -346,10 +347,17 @@
 		/* Try to close files now, so we can wake up the backend
 		 * and do more I/O before dropping into select
 		 */
-		if (!do_read && !do_write)
-		    try_close(b);
-	    }
-	}
+		if (!do_read && !do_write) {
+                    if (i == 1)
+                        /* delay closing STDOUT until all the other fds are closed */
+                        close_stdout_delayed = 1;
+                    else
+		        try_close(b);
+                }
+            }
+        }
+        if (close_stdout_delayed)
+            try_close(cb+1);
 
 	/* All done with reads/writes after backend exited */
 	if (backend_exited) {
