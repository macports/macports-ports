--- libguile/guile.c.org	2005-06-23 08:43:29.000000000 +0200
+++ libguile/guile.c	2005-06-23 08:44:09.000000000 +0200
@@ -88,7 +88,7 @@
 {
 #ifdef DYNAMIC_LINKING
   /* libtool automagically inserts this variable into your executable... */
-  extern const scm_lt_dlsymlist lt_preloaded_symbols[];
+  extern const scm_lt_dlsymlist *lt_preloaded_symbols;
   scm_lt_dlpreload_default (lt_preloaded_symbols);
 #endif
   scm_boot_guile (argc, argv, inner_main, 0);
