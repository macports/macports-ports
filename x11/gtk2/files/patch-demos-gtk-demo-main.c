--- demos/gtk-demo/main.c.orig	Fri May 17 04:11:57 2002
+++ demos/gtk-demo/main.c	Sat Jan 18 03:54:38 2003
@@ -96,7 +96,7 @@
     {
       int c;
       
-#ifndef G_OS_WIN32
+#ifdef HAVE_FLOCKFILE
       c = getc_unlocked (stream);
 #else
       c = getc (stream);
