--- game.c.orig	2005-04-15 00:06:21.000000000 -0400
+++ game.c	2005-04-15 00:06:45.000000000 -0400
@@ -29,6 +29,7 @@
 int xread(FILE *f, char *buf, int size);
 int xwrite(FILE *f, char *buf, int size);
 void stat_display( char *mbuf, int round);
+static void mark_cont(long mapi);
 
 /*
 Initialize a new game.  Here we generate a new random map, put cities
@@ -407,8 +408,6 @@
 int good_cont (mapi)
 long mapi;
 {
-	static void mark_cont();
-
 	long val;
 
 	ncity = 0; /* nothing seen yet */
