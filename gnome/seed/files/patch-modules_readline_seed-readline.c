'Function' is deprecated - patch to work with older readline API
(e.g., currently in base) or new (e.g., readline 6.3.3 in ports).

http://lists.gnu.org/archive/html/bug-readline/2014-03/msg00002.html

--- modules/readline/seed-readline.c.orig	2010-08-30 15:37:39.000000000 -0600
+++ modules/readline/seed-readline.c	2014-04-15 13:00:13.000000000 -0600
@@ -77,7 +77,7 @@
   key = seed_value_to_string(ctx, arguments[0], exception);
   c = seed_make_rl_closure((SeedObject) arguments[1]);
 
-  rl_bind_key(*key, (Function *) c);
+  rl_bind_key(*key, (rl_command_func_t *) c);
 
   g_free(key);

