--- bmore.h.orig	Mon Jan  6 04:28:07 2003
+++ bmore.h	Mon Jan  6 04:28:21 2003
@@ -48,7 +48,7 @@
 #	include <unistd.h>
 #if HAVE_NCURSES_H
 #   include <ncurses.h>
-#	include <ncurses/term.h>
+#	include <term.h>
 #else
 #   include <curses.h>
 #	include <term.h>
