$OpenBSD: patch-source_server_c,v 1.1 2003/04/16 09:04:24 avsm Exp $
--- source/server.c.orig	Mon Apr 14 23:56:28 2003
+++ source/server.c	Mon Apr 14 23:56:59 2003
@@ -144,7 +144,7 @@ void	close_server (int cs_index, char *m
 			if (x_debug & DEBUG_OUTBOUND)
 				yell("Closing server %d because [%s]",
 					   cs_index, message ? message : empty_string);
-			snprintf(buffer, BIG_BUFFER_SIZE, "QUIT :%s\n", message);
+			snprintf(buffer, sizeof buffer, "QUIT :%s\n", message);
 #ifdef HAVE_SSL
 			if (get_server_ssl(cs_index))
 				SSL_write(server_list[cs_index].ssl_fd, buffer, strlen(buffer));
