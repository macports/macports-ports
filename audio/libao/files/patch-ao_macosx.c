--- src/plugins/macosx/ao_macosx.c Fri Jan 16 16:58:56 2004
+++ src/plugins/macosx/ao_macosx.c Fri Jan 16 17:22:38 2004
@@ -173,6 +173,26 @@
        return 0;
     }
 
+       if (internal->outputStreamBasicDescription.mChannelsPerFrame != format->channels)
+       {
+               internal->outputStreamBasicDescription.mChannelsPerFrame = format->channels;
+               internal->outputStreamBasicDescription.mBytesPerFrame =
+                       internal->outputStreamBasicDescription.mChannelsPerFrame * sizeof (float);
+               internal->outputStreamBasicDescription.mBytesPerPacket =
+                       internal->outputStreamBasicDescription.mBytesPerFrame *
+                       internal->outputStreamBasicDescription.mFramesPerPacket;
+               status = AudioDeviceSetProperty(internal->outputDeviceID, 0, 0, 0,
+                       kAudioDevicePropertyStreamFormat,
+                       sizeof (internal->outputStreamBasicDescription),
+                       &internal->outputStreamBasicDescription);
+               if (status != noErr)
+               {
+                       fprintf(stderr, "ao_macosx_open: AudioDeviceSetProperty returned %.*s when setting kAudioDevicePropertyStreamFormat\n",
+                               (int) sizeof (status), (char *) &status);
+                       return 0;
+               }
+       }
+
     fprintf(stderr, "hardware format...\n");
     fprintf(stderr, "%f mSampleRate\n", internal->outputStreamBasicDescription.mSampleRate);
     fprintf(stderr, "%c%c%c%c mFormatID\n", (int)(internal->outputStreamBasicDescription.mFormatID & 0xff000000) >> 24,
