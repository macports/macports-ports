--- libgames-support/games-network.h.org	Sun Sep 19 14:30:49 2004
+++ libgames-support/games-network.h	Sun Sep 19 14:30:44 2004
@@ -3,8 +3,8 @@
 
 extern char *game_server;
 extern guint whose_turn;
-const char *player_name;
-const char *opponent_name;
+extern const char *player_name;
+extern const char *opponent_name;
 extern guint game_in_progress;
 
 typedef struct {
