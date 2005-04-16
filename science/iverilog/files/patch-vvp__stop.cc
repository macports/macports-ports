--- vvp/stop.cc.orig	2005-04-16 16:32:21.000000000 -0400
+++ vvp/stop.cc	2005-04-16 16:33:55.000000000 -0400
@@ -353,7 +353,7 @@
 	     "of available commands.\n");
 }
 
-struct {
+static struct {
       const char*name;
       void (*proc)(unsigned argc, char*argv[]);
       const char*summary;
