--- tidy.c.orig	Fri Aug  4 19:21:05 2000
+++ tidy.c	Mon Nov 19 14:39:50 2001
@@ -785,6 +785,8 @@
                 Quiet = yes;
             else if (strcmp(arg, "slides") == 0)
                 BurstSlides = yes;
+            else if (strcmp(arg, "preserve") == 0)
+                PreserveEntities = yes;
             else if (strcmp(arg, "help") == 0 ||
                      argv[1][1] == '?'|| argv[1][1] == 'h')
             {
