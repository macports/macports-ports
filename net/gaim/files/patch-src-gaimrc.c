--- src/gaimrc.c.orig	Tue May 20 17:42:56 2003
+++ src/gaimrc.c	Tue May 20 17:43:33 2003
@@ -1440,8 +1440,8 @@
 #else
 	report_idle = IDLE_GAIM;
 #endif
-	web_browser = BROWSER_NETSCAPE;
-	g_snprintf(web_command, sizeof(web_command), "xterm -e lynx %%s");
+	web_browser = BROWSER_MANUAL;
+	g_snprintf(web_command, sizeof(web_command), "open %%s");
 
 	auto_away = 10;
 	a = g_new0(struct away_message, 1);
