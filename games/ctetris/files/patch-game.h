--- game.h.orig	2005-10-06 13:34:03.000000000 -0700
+++ game.h	2005-10-06 13:36:05.000000000 -0700
@@ -1,9 +1,9 @@
 #ifndef _GAME_H
 #define _GAME_H
 
-void init_board(char [][]);
-void remove_this_row(WINDOW *, char [][], unsigned char);
-void remove_rows(WINDOW *, char [][], unsigned int *, const char);
+void init_board(char [BOARD_HEIGHT][BOARD_WIDTH]);
+void remove_this_row(WINDOW *, char [BOARD_HEIGHT][BOARD_WIDTH], unsigned char);
+void remove_rows(WINDOW *, char [BOARD_HEIGHT][BOARD_WIDTH], unsigned int *, const char);
 void calc_level(const unsigned int, char *);
 unsigned int start_game();
 
