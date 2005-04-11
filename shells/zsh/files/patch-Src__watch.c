--- Src/watch.c.orig	2005-04-03 03:44:58.000000000 -0400
+++ Src/watch.c	2005-04-03 04:45:19.000000000 -0400
@@ -103,6 +103,9 @@
 # ifdef HAVE_STRUCT_UTMPX_UT_HOST
 #  define WATCH_UTMP_UT_HOST 1
 # endif
+# ifdef __APPLE__
+#  define ut_name ut_user
+# endif
 #endif
 
 #if !defined(WATCH_STRUCT_UTMP) && defined(HAVE_STRUCT_UTMP) && defined(REAL_UTMP_FILE)
