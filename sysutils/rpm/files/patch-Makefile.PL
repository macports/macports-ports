--- perl/Makefile.PL.orig	2005-11-19 17:42:19.000000000 +0100
+++ perl/Makefile.PL	2007-02-22 12:29:08.000000000 +0100
@@ -6,6 +6,7 @@
 
 if (-e '../system.h') {
   $libs = "-L../lib/ -lrpm";
+  push @incs, '-I../lib/.libs';
   push @incs, '-I../lib';
   push @incs, '-I../rpmdb';
   push @incs, '-I../rpmio';
