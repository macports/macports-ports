--- src/profiles.c.orig	2012-10-30 14:12:10.000000000 -0600
+++ src/profiles.c	2012-10-30 14:13:49.000000000 -0600
@@ -204,14 +204,24 @@
 
   for (i = 0; i < ctx->nb_streams; i++)
   {
+#if LIBAVFORMAT_BUILD < 4621
     if (audio_stream == -1 &&
         ctx->streams[i]->codec->codec_type == CODEC_TYPE_AUDIO)
+#else
+    if (audio_stream == -1 &&
+        ctx->streams[i]->codec->codec_type == AVMEDIA_TYPE_AUDIO)
+#endif 
     {
       audio_stream = i;
       continue;
     }
+#if LIBAVFORMAT_BUILD < 4621
     else if (video_stream == -1 &&
              ctx->streams[i]->codec->codec_type == CODEC_TYPE_VIDEO)
+#else
+    else if (video_stream == -1 &&
+             ctx->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO)
+#endif
     {
       video_stream = i;
       continue;
@@ -280,7 +290,7 @@
   if (!dlna->inited)
     dlna = dlna_init ();
   
-  if (av_open_input_file (&ctx, filename, NULL, 0, NULL) != 0)
+  if (avformat_open_input (&ctx, filename, NULL, NULL) != 0)
   {
     if (dlna->verbosity)
       fprintf (stderr, "can't open file: %s\n", filename);
@@ -334,7 +344,7 @@
     p = p->next;
   }
 
-  av_close_input_file (ctx);
+  avformat_close_input (ctx);
   free (codecs);
   return profile;
 }
