diff -ru ../dhcp-3.1.0.orig/minires/res_send.c ./minires/res_send.c
--- ../dhcp-3.1.0.orig/minires/res_send.c	2005-03-17 12:15:19.000000000 -0800
+++ ./minires/res_send.c	2007-12-11 22:02:19.000000000 -0800
@@ -80,6 +80,21 @@
 #endif /* LIBC_SCCS and not lint */
 
 /* Rename the I/O functions in case we're tracing. */
+#include <omapip/omapip_p.h>
+
+ssize_t trace_mr_send (int, void *, size_t, int);
+ssize_t trace_mr_recvfrom (int s, void *, size_t, int,
+                           struct sockaddr *, SOCKLEN_T *);
+ssize_t trace_mr_read (int, void *, size_t);
+int trace_mr_connect (int s, struct sockaddr *, SOCKLEN_T);
+int trace_mr_socket (int, int, int);
+int trace_mr_bind (int, struct sockaddr *, SOCKLEN_T);
+int trace_mr_close (int);
+time_t trace_mr_time (time_t *);
+int trace_mr_select (int, fd_set *, fd_set *, fd_set *, struct timeval *);
+unsigned int trace_mr_res_randomid (unsigned int);
+
+
 #define send		trace_mr_send
 #define recvfrom	trace_mr_recvfrom
 #define	read		trace_mr_read
