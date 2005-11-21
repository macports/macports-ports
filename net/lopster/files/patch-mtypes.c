--- src/mtypes.c	Sat Jul  3 08:19:20 2004
+++ src/mtypes.c	Thu Oct  7 05:06:01 2004
@@ -125,8 +125,7 @@
   //////////////////////////////////////////////////////////////
   mtype = &MType[MEDIA_MP3];
   
-  mtype->app = g_list_append(mtype->app, app_new("xmms %f", "Open"));
-  mtype->app = g_list_append(mtype->app, app_new("xmms -e %f", "Enqueue"));
+  mtype->app = g_list_append(mtype->app, app_new("open '%f'", "Open"));
   mtype->suffix = 
     g_list_append(mtype->suffix, suffix_new("mp3"));
 #ifdef HAVE_OGG
@@ -137,7 +136,7 @@
   //////////////////////////////////////////////////////////////
   mtype = &MType[MEDIA_VIDEO];
   
-  mtype->app = g_list_append(mtype->app, app_new("mplayer %f", "MPlayer"));
+  mtype->app = g_list_append(mtype->app, app_new("open '%f'", "Open"));
   mtype->suffix = 
     g_list_append(mtype->suffix, suffix_new("mpg mpeg"));
   mtype->suffix = 
@@ -150,7 +149,7 @@
   //////////////////////////////////////////////////////////////
   mtype = &MType[MEDIA_IMAGE];
   
-  mtype->app = g_list_append(mtype->app, app_new("ee %f", "Electric eyes"));
+  mtype->app = g_list_append(mtype->app, app_new("open '%f'", "Open"));
   mtype->suffix = 
     g_list_append(mtype->suffix, suffix_new("jpg jpeg"));
   mtype->suffix = 
@@ -163,8 +162,7 @@
   //////////////////////////////////////////////////////////////
   mtype = &MType[MEDIA_FOLDER];
   
-  mtype->app = g_list_append(mtype->app, app_new("gmc %f", "Browse"));
-  mtype->app = g_list_append(mtype->app, app_new("xmms %f", "Xmms"));
+  mtype->app = g_list_append(mtype->app, app_new("open `dirname '%f'`", "Browse"));
 }
 */
