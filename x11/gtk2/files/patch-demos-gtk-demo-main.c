--- demos/gtk-demo/main.c	Fri May 17 04:00:25 2002
+++ demos/gtk-demo/main.c	Sun Jun 23 02:06:02 2002
@@ -96,7 +96,7 @@
     {
       int c;
       
-#ifndef G_OS_WIN32
+#ifdef HAVE_FLOCKFILE
       c = getc_unlocked (stream);
 #else
       c = getc (stream);
