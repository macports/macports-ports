--- audio_carbon.c.bak	2006-03-11 18:24:37.000000000 +0100
+++ audio_carbon.c	2006-03-11 18:25:03.000000000 +0100
@@ -94,7 +94,7 @@
 }
 
 static
-int wait(struct buffer *buffer)
+int delay(struct buffer *buffer)
 {
   if (MPWaitOnSemaphore(buffer->semaphore, kDurationForever) != noErr) {
     audio_error = _("MPWaitOnSemaphore() failed");
@@ -263,7 +263,7 @@
   /* wait for block to finish playing */
 
   if (buffer->pcm_nsamples == 0) {
-    if (wait(buffer) == -1)
+    if (delay(buffer) == -1)
       return -1;
 
     buffer->pcm_length = 0;
