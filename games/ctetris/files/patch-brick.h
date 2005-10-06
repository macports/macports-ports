--- brick.h.orig	2005-10-06 13:34:23.000000000 -0700
+++ brick.h	2005-10-06 13:38:33.000000000 -0700
@@ -1,10 +1,10 @@
 #ifndef _BRICK_H
 #define _BRICK_H
 
-void change_direction(char [][], char [][], const unsigned char, const unsigned char, const char);
-void find_index(char [][], unsigned char *, unsigned char *);
-char check_brick(char [][], char [][], const unsigned char, const unsigned char);
-void draw_to_board(char [][], char [][], const char, const unsigned char, const unsigned char);
+void change_direction(char [BOARD_HEIGHT][BOARD_WIDTH], char [4][4], const unsigned char, const unsigned char, const char);
+void find_index(char [4][4], unsigned char *, unsigned char *);
+char check_brick(char [BOARD_HEIGHT][BOARD_WIDTH], char [4][4], const unsigned char, const unsigned char);
+void draw_to_board(char [BOARD_HEIGHT][BOARD_WIDTH], char [4][4], const char, const unsigned char, const unsigned char);
 
 char brick_digit[7][4][4];
 
