--- src/sqsh_readline.c.orig	2015-02-11 11:00:04.000000000 +1300
+++ src/sqsh_readline.c	2015-02-11 11:08:13.000000000 +1300
@@ -159,7 +159,7 @@
 
     rl_readline_name                 = "sqsh" ;
     rl_completion_entry_function     = (rl_compentry_func_t*)sqsh_completion ;
-    rl_attempted_completion_function = (CPPFunction*)sqsh_completion ;
+    rl_attempted_completion_function = (rl_completion_func_t*)sqsh_completion ;
 
     /*
      * sqsh-2.1.8 - Remove '@' and '$' from the readline default list of word break
