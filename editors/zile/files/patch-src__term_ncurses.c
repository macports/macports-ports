--- src/term_ncurses.c.orig	2006-09-13 20:54:39.000000000 +0100
+++ src/term_ncurses.c	2006-09-21 22:02:01.000000000 +0100
@@ -155,6 +155,7 @@
   case KEY_DC:		/* DEL */
     return KBD_DEL;
   case KEY_BACKSPACE:	/* BS */
+	return KBD_CTRL | 'h';
   case 0177:		/* BS */
     return KBD_BS;
   case KEY_IC:		/* INSERT */
