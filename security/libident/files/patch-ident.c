--- ident.c.orig	2009-06-16 21:52:53.000000000 -0700
+++ ident.c	2009-06-16 21:53:04.000000000 -0700
@@ -37,7 +37,7 @@
 IDENT *ident_lookup (int fd, int timeout)
 {
     struct sockaddr_storage localaddr, remoteaddr;
-    int len;
+    socklen_t len;
     
     len = sizeof(remoteaddr);
     if (getpeername(fd, (struct sockaddr*)&remoteaddr, &len) < 0)
