--- demos/gtk-demo/main.c.orig	Fri Oct  4 07:49:31 2002
+++ demos/gtk-demo/main.c	Mon Apr  7 02:00:38 2003
@@ -96,7 +96,7 @@
     {
       int c;
       
-#ifndef G_OS_WIN32
+#ifdef HAVE_FLOCKFILE
       c = getc_unlocked (stream);
 #else
       c = getc (stream);
