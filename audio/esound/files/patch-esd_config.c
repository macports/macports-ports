--- ../esound-0.2.35.bak/esd_config.c	Wed Mar 23 00:04:57 2005
+++ esd_config.c	Wed Mar 23 00:05:01 2005
@@ -9,7 +9,7 @@
 int esd_no_spawn=1; /* If we can't even find the system config file,
 		       things are screwed up - don't try to make things
 		       worse. */
-int esd_spawn_wait_ms=100; /* Time to wait trying to connect to an
+int esd_spawn_wait_ms=999; /* Time to wait trying to connect to an
 			      autospawned ESD, in milliseconds. */
 char esd_spawn_options[LINEBUF_SIZE] = "-terminate -nobeeps -as 2";
 
