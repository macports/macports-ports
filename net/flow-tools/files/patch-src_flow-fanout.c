--- src/flow-fanout.c.orig	Tue Jun  7 22:52:16 2005
+++ src/flow-fanout.c	Tue Jun  7 22:52:39 2005
@@ -855,6 +855,7 @@
     } /* if FD_ISSET */
 
 skip1:
+	;
 
     if (sig_quit_flag) {
       fterr_info("SIGQUIT");
