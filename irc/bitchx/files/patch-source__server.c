--- source/server.c.orig	Thu Apr  1 04:30:58 2004
+++ source/server.c	Thu Apr  1 04:31:12 2004
@@ -151,7 +151,7 @@
 			if (x_debug & DEBUG_OUTBOUND)
 				yell("Closing server %d because [%s]",
 					   cs_index, message ? message : empty_string);
-			snprintf(buffer, BIG_BUFFER_SIZE, "QUIT :%s\n", message);
+			snprintf(buffer, sizeof buffer, "QUIT :%s\n", message);
 #ifdef HAVE_SSL
 			if (get_server_ssl(cs_index))
 				SSL_write(server_list[cs_index].ssl_fd, buffer, strlen(buffer));
