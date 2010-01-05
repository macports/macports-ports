diff -r -u screen-4.0.3.orig/process.c screen-4.0.3/process.c
--- process.c   2008-07-06 23:40:16.000000000 -0700
+++ process.c   2008-07-06 23:47:55.000000000 -0700
@@ -5466,7 +5466,7 @@
       *buf = 0;
       return;
     }
-  act.nr = (int)data;
+  act.nr = (int)(intptr_t)data;
   act.args = noargs;
   act.argl = 0;
   DoAction(&act, -1);

