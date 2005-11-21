--- src/global.c	Sun Aug 29 11:33:38 2004
+++ src/global.c	Thu Oct  7 05:06:01 2004
@@ -525,12 +525,20 @@
     return MEDIA_AUDIO;
   else if (!g_strcasecmp(suffix, "au"))
     return MEDIA_AUDIO;
+  else if (!g_strcasecmp(suffix, "aiff"))
+    return MEDIA_AUDIO;
   else if (!g_strcasecmp(suffix, "ogg"))
 #ifdef HAVE_OGG
     return MEDIA_MP3;
 #else
     return MEDIA_AUDIO;
 #endif
+  else if (!g_strcasecmp(suffix, "flac"))
+    return MEDIA_MP3;
+  else if (!g_strcasecmp(suffix, "m4a"))
+    return MEDIA_MP3;
+  else if (!g_strcasecmp(suffix, "wma"))
+    return MEDIA_MP3;
   else if (!g_strcasecmp(suffix, "mpg"))
     return MEDIA_VIDEO;
   else if (!g_strcasecmp(suffix, "mpeg"))
@@ -547,6 +555,8 @@
     return MEDIA_VIDEO;
   else if (!g_strcasecmp(suffix, "wmf"))
     return MEDIA_VIDEO;
+  else if (!g_strcasecmp(suffix, "wmv"))
+    return MEDIA_VIDEO;
   else if (!g_strcasecmp(suffix, "bmp"))
     return MEDIA_IMAGE;
   else if (!g_strcasecmp(suffix, "png"))
@@ -591,6 +601,18 @@
     return MEDIA_APPLICATION;
   else if (!g_strcasecmp(suffix, "rpm"))
     return MEDIA_APPLICATION;
+  else if (!g_strcasecmp(suffix, "hqx"))
+    return MEDIA_APPLICATION;
+  else if (!g_strcasecmp(suffix, "sit"))
+    return MEDIA_APPLICATION;
+  else if (!g_strcasecmp(suffix, "sitx"))
+    return MEDIA_APPLICATION;
+  else if (!g_strcasecmp(suffix, "dmg"))
+    return MEDIA_APPLICATION;
+  else if (!g_strcasecmp(suffix, "img"))
+    return MEDIA_APPLICATION;
+  else if (!g_strcasecmp(suffix, "toast"))
+    return MEDIA_APPLICATION;
   else
     return MEDIA_NONE;
 }
@@ -3462,7 +3484,7 @@
   global.options.resume_timeout = 60;
   global.options.check_lib_for_download = 1;
   global.options.time_display = 0;
-  global.options.browser = g_strdup("dillo %s");
+  global.options.browser = g_strdup("launch -l '%s'");
   global.options.filetips = 1;
 
   global.options.down_speed[0] = SPEED_RED;
@@ -3545,7 +3567,7 @@
   global.allowed_ports = NULL;
 
   global.auto_save = NULL;
-  global.ping_command = g_strdup("/bin/ping -c 3 $IP");
+  global.ping_command = g_strdup("/sbin/ping -c 3 $IP");
 
   global.browse_width[0] = 369;
   global.browse_width[1] = 80;
