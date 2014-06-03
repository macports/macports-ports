--- source/signals.c	1994-07-21 21:47:42.000000000 -0400
+++ source/signals.c	2011-12-30 17:19:16.000000000 -0500
@@ -114,7 +114,7 @@
     {
       if(++signal_count > 10)	/* Be safe. We will die if persistent enough. */
 	(void) signal(sig, SIG_DFL);
-      return;
+      return 0;
     }
   error_sig = sig;
 
@@ -145,7 +145,7 @@
 	      if (wait_for_more)
 		put_buffer(" -more-", MSG_LINE, 0);
 	      put_qio();
-	      return;		/* OK. We don't quit. */
+	      return 0;		/* OK. We don't quit. */
 	    }
 	  (void) strcpy(died_from, "Interrupting");
 	}
