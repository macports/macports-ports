--- AudioFile.m.orig	2005-04-19 07:36:43.000000000 -0400
+++ AudioFile.m	2005-04-19 07:36:51.000000000 -0400
@@ -23,8 +23,7 @@
 
 #import "AudioFile.h"
 #import "ProgressPanel.h"
-
-@class AudioFileMP3;
+#import "AudioFileMP3.h"
 
 NSString	*AudioFileAudioThreadFinishedNotification = @"AudioFileAudioThreadFinishedNotification";
 
