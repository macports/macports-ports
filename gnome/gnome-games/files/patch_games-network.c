--- libgames-support/games-network.c.org	2005-03-25 11:44:36.000000000 +0100
+++ libgames-support/games-network.c	2005-03-25 11:44:55.000000000 +0100
@@ -60,7 +60,7 @@
 const char *player_name;
 const char *opponent_name;
 
-char *game_server; 
+/* char *game_server; */
 static char *game_port;
 static pid_t server_pid = - 1;
 
