--- screen.h.orig	2005-10-06 13:33:57.000000000 -0700
+++ screen.h	2005-10-06 13:37:05.000000000 -0700
@@ -13,8 +13,8 @@
 void destroy_preview_win(WINDOW *);
 void destroy_score_win(WINDOW *);
 void show_brick_pice(WINDOW *, const char, const unsigned char, const unsigned char);
-void show_board_win(WINDOW *, char [][], char [][], const char, const unsigned char, const unsigned char);
-void show_brick(WINDOW *, char [][], const char, const unsigned char, const unsigned char);
+void show_board_win(WINDOW *, char [BOARD_HEIGHT][BOARD_WIDTH], char [4][4], const char, const unsigned char, const unsigned char);
+void show_brick(WINDOW *, char [4][4], const char, const unsigned char, const unsigned char);
 void show_brick_preview(WINDOW *, const char);
 int get_key(WINDOW *);
 int old_get_key(WINDOW *);
@@ -27,7 +27,7 @@
 void show_pause(WINDOW *);
 void show_headline();
 void show_colorized_char(const unsigned char, const unsigned char, const char, const char);
-void show_remove_row(WINDOW *, char [][], const unsigned char);
+void show_remove_row(WINDOW *, char [BOARD_HEIGHT][BOARD_WIDTH], const unsigned char);
 void refresh_win(WINDOW *);
 void show_yes_no(WINDOW *, const char);
 char yes_no_question(const char *);
