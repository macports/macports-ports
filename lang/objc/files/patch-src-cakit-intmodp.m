--- src/cakit/intmodp.m	2001-07-09 20:38:07.000000000 +0200
+++ src/cakit/intmodp.m	2007-09-03 20:55:04.000000000 +0200
@@ -220,10 +220,7 @@
 
 static void modp_clear(modp_c *c,modp_args args)
 {
-    /* nothing to clear, but the following might help... */
-    #ifndef DEBUG
     *c = (modp_t)0xcafebabe;
-    #endif
 }
 
 static void modp_copy(modp_c *c,modp_t a,modp_args args)
@@ -239,9 +236,7 @@
 static void modp_move(modp_c *c,modp_c *a,modp_args args)
 {
     *c = *a;
-    #ifndef DEBUG
     *a = (modp_t)0xcafebabe;
-    #endif
 }
 
 #if !modp_isvalue
