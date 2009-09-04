--- src/socket.c.orig	2009-09-03 21:48:19.000000000 -0700
+++ src/socket.c	2009-09-03 21:49:21.000000000 -0700
@@ -2600,7 +2600,7 @@
 	    socks_with_lines--;
 
 	if (line->attrs & (F_TFPROMPT)) {
-	    incoming_text = line;
+	    incoming_text = (String *)line;
 	    handle_prompt(incoming_text, 0, TRUE);
 	    continue;
 	}
