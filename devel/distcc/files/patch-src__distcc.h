--- src/distcc.h.orig	Wed Nov  3 13:43:19 2004
+++ src/distcc.h	Wed Nov  3 13:43:32 2004
@@ -265,7 +265,7 @@
 
 int dcc_readx(int fd, void *buf, size_t len);
 int dcc_pump_sendfile(int ofd, int ifd, size_t n);
-int dcc_r_str_alloc(int fd, size_t len, char **buf);
+int dcc_r_str_alloc(int fd, unsigned len, char **buf);
 
 int tcp_cork_sock(int fd, int corked);
 int dcc_close(int fd);
