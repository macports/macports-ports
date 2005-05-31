--- opennet.c.orig	2005-05-31 15:38:58.000000000 -0400
+++ opennet.c	2005-05-31 15:39:00.000000000 -0400
@@ -79,7 +79,7 @@
 	int flags;
 	mode_t mode;
 };
-struct opennet_url_info opennet_urls[256];
+static struct opennet_url_info opennet_urls[256];
 
 /* Do things required for network access. */
 int opennet_init(void) {
