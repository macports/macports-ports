--- src/kernel/qaccessible_mac.cpp.orig	2005-06-16 09:30:13.000000000 -0700
+++ src/kernel/qaccessible_mac.cpp	2005-06-16 09:30:55.000000000 -0700
@@ -182,7 +182,7 @@
     }
 }
 
-struct {
+struct QAccessibleTextBindings {
     int qt;
     CFStringRef mac;
     bool settable;
