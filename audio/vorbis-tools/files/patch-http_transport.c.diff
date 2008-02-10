diff -Naurd vorbis-tools-1.1.1.old/ogg123/http_transport.c vorbis-tools-1.1.1.new/ogg123/http_transport.c
--- vorbis-tools-1.1.1.old/ogg123/http_transport.c	2005-06-13 15:11:44.000000000 +0200
+++ vorbis-tools-1.1.1.new/ogg123/http_transport.c	2006-12-10 00:50:48.000000000 +0100
@@ -116,7 +116,6 @@
   if (inputOpts.ProxyTunnel)
     curl_easy_setopt (handle, CURLOPT_HTTPPROXYTUNNEL, inputOpts.ProxyTunnel);
   */
-  curl_easy_setopt(handle, CURLOPT_MUTE, 1);
   curl_easy_setopt(handle, CURLOPT_ERRORBUFFER, private->error);
   curl_easy_setopt(handle, CURLOPT_PROGRESSFUNCTION, progress_callback);
   curl_easy_setopt(handle, CURLOPT_PROGRESSDATA, private);
