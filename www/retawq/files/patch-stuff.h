--- stuff.h.orig	Wed Feb 23 13:01:18 2005
+++ stuff.h	Wed Feb 23 13:01:39 2005
@@ -174,7 +174,7 @@
 #include <sys/stat.h>
 #endif
 
-#if HAVE_TERMIOS_H && ( (CONFIG_CONSOLE) || (CONFIG_TG == TG_BICURSES) )
+#if HAVE_TERMIOS_H && ( (CONFIG_CONSOLE) || (CONFIG_TG == TG_BICURSES) ) && !__APPLE__
 #include <termios.h>
 #define MIGHT_DO_TERMIOS 1
 #else
