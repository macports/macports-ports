--- hier.c.orig	Wed Jan 12 16:54:01 2005
+++ hier.c	Wed Jan 12 16:54:25 2005
@@ -1,11 +1,11 @@
-#include "auto_home.h"
+const char auto_home[] = "/opt/dports-dev/net/djbdns/work/destroot/opt/local";
 
 void hier()
 {
-  c("/","etc","dnsroots.global",-1,-1,0644);
+  c(auto_home,"etc","dnsroots.global",-1,-1,0644);
 
-  h(auto_home,-1,-1,02755);
-  d(auto_home,"bin",-1,-1,02755);
+  h(auto_home,-1,-1,0755);
+  d(auto_home,"bin",-1,-1,0755);
 
   c(auto_home,"bin","dnscache-conf",-1,-1,0755);
   c(auto_home,"bin","tinydns-conf",-1,-1,0755);
