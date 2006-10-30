diff -ru ../bmon-2.1.0.orig/src/out_audio.c ./src/out_audio.c
--- ../bmon-2.1.0.orig/src/out_audio.c	2005-04-05 08:01:33.000000000 -0700
+++ ./src/out_audio.c	2006-10-26 17:24:00.197478122 -0700
@@ -141,7 +141,7 @@
 	.om_draw = audio_draw,
 	.om_set_opts = audio_set_opts,
 	.om_probe = audio_probe,
-	.om_shutdown audio_shutdown,
+	.om_shutdown = audio_shutdown,
 };
 
 static void __init audio_init(void)
