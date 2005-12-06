--- glib/gmain.c.orig	2005-05-01 18:24:23.000000000 -0400
+++ glib/gmain.c	2005-05-01 18:24:40.000000000 -0400
@@ -52,7 +52,7 @@
 /* The poll() emulation on OS/X doesn't handle fds=NULL, nfds=0,
  * so we prefer our own poll emulation.
  */
-#ifdef _POLL_EMUL_H_
+#ifdef __APPLE__
 #undef HAVE_POLL
 #endif
    
