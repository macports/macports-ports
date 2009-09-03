--- common/gnu_getopt.h.orig	2009-09-03 14:51:53.000000000 -0700
+++ common/gnu_getopt.h	2009-09-03 14:52:33.000000000 -0700
@@ -58,10 +58,12 @@
 
 #else
 
+__BEGIN_DECLS
 extern char *optarg;
 extern int optind;
 extern int opterr;
 extern int optopt;
+__END_DECLS
 
 struct option {
     const char *name;
