diff -ur qmail-1.03.orig/dns.c qmail-1.03/dns.c
--- dns.c.orig	Mon Jun 15 06:53:16 1998
+++ dns.c	Sat Jun  5 15:52:46 2004
@@ -2,6 +2,7 @@
 #include <netdb.h>
 #include <sys/types.h>
 #include <netinet/in.h>
+#include <nameser8_compat.h>
 #include <arpa/nameser.h>
 #include <resolv.h>
 #include <errno.h>
