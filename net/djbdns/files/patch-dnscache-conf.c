--- dnscache-conf.c.orig	Sat Sep 23 17:39:21 2000
+++ dnscache-conf.c	Sat Sep 23 17:42:43 2000
@@ -89,13 +89,13 @@
   if (chdir(auto_home) == -1)
     strerr_die4sys(111,FATAL,"unable to switch to ",auto_home,": ");
 
-  fdrootservers = open_read("/etc/dnsroots.local");
+  fdrootservers = open_read("etc/dnsroots.local");
   if (fdrootservers == -1) {
     if (errno != error_noent)
-      strerr_die2sys(111,FATAL,"unable to open /etc/dnsroots.local: ");
-    fdrootservers = open_read("/etc/dnsroots.global");
+      strerr_die4sys(111,FATAL,"unable to open ",auto_home,"/etc/dnsroots.local: ");
+    fdrootservers = open_read("etc/dnsroots.global");
     if (fdrootservers == -1)
-      strerr_die2sys(111,FATAL,"unable to open /etc/dnsroots.global: ");
+      strerr_die4sys(111,FATAL,"unable to open ",auto_home,"/etc/dnsroots.global: ");
   }
 
   init(dir,FATAL);
