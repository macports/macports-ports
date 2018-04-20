--- http/servlet/http_servlet_file.c.orig	Sun Jan 30 18:53:42 2005
+++ http/servlet/http_servlet_file.c	Sun Jan 30 18:54:39 2005
@@ -419,6 +419,7 @@
 		return;
 	}
 
+#ifndef __APPLE__
 	/* Send file contents, using sendfile(2) if possible */
 	if ((sock = http_response_get_raw_socket(resp)) != -1) {
 		struct http_servlet_file_serve_state state;
@@ -444,6 +445,7 @@
 		/* Close file */
 		pthread_cleanup_pop(1);
 	} else {
+#endif /* !__APPLE__ */
 		FILE *fp;
 		int ret;
 
@@ -466,7 +468,9 @@
 
 		/* Close file */
 		pthread_cleanup_pop(1);
+#ifndef __APPLE__
 	}
+#endif /* !__APPLE__ */
 }
 
 /*
