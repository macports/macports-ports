diff -urN ../ijb-zlib-11.orig/jcc.h ./jcc.h
--- ../ijb-zlib-11.orig/jcc.h	Thu Aug  3 23:39:31 2000
+++ ./jcc.h	Thu Jan  6 15:39:42 2005
@@ -339,6 +339,7 @@
 extern void client_cookie_adder(struct client_state *csp);
 extern void client_xtra_adder(struct client_state *csp);
 extern void client_x_forwarded_adder(struct client_state *csp);
+extern void server_conn_close_adder(struct client_state *csp);
 
 /* interceptors from filters.c
 */
