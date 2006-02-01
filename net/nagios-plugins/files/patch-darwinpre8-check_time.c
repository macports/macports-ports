--- plugins/check_time.c.org	2006-02-01 13:05:00.000000000 -0800
+++ plugins/check_time.c	2006-02-01 13:06:02.000000000 -0800
@@ -33,7 +33,7 @@
 
 #define	UNIX_EPOCH 2208988800UL
 
-uint32_t server_time, raw_server_time;
+unsigned long server_time, raw_server_time;
 time_t diff_time;
 int warning_time = 0;
 int check_warning_time = FALSE;
