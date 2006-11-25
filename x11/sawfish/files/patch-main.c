--- ../sawfish-1.3.orig/src/main.c	2006-08-07 09:49:10.000000000 -0600
+++ src/main.c	2006-08-07 09:49:22.000000000 -0600
@@ -50,7 +50,7 @@
 int exit_code = ec_no_exit;
 
 /* Saved value of argv[0] */
-static char *prog_name;
+char *prog_name;
 
 DEFSYM(sawfish_directory, "sawfish-directory");
 DEFSYM(sawfish_lisp_lib_directory, "sawfish-lisp-lib-directory");
