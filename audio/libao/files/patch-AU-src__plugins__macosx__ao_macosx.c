--- src/plugins/macosx/ao_macosx.c.orig	2010-03-24 07:48:38.000000000 +0100
+++ src/plugins/macosx/ao_macosx.c	2010-03-27 09:30:34.000000000 +0100
@@ -33,6 +33,7 @@
    audio samples rather than having them pushed at it (which is nice
    when you are wanting to do good buffering of audio).  */
 
+#include <CoreServices/CoreServices.h>
 #include <AudioUnit/AudioUnit.h>
 #include <AudioUnit/AUComponent.h>
 #include <stdio.h>
@@ -71,7 +72,7 @@
 typedef struct ao_macosx_internal
 {
   /* Stuff describing the CoreAudio device */
-  AudioComponentInstance       outputAudioUnit;
+  ComponentInstance       outputAudioUnit;
 
   /* Keep track of whether the output stream has actually been
      started/stopped */
@@ -224,8 +225,8 @@
 {
   ao_macosx_internal *internal = (ao_macosx_internal *) device->internal;
   OSStatus result = noErr;
-  AudioComponent comp;
-  AudioComponentDescription desc;
+  Component comp;
+  ComponentDescription desc;
   AudioStreamBasicDescription requestedDesc;
   AURenderCallbackStruct      input;
   UInt32 i_param_size;
@@ -237,14 +238,14 @@
   desc.componentFlags = 0;
   desc.componentFlagsMask = 0;
 
-  comp = AudioComponentFindNext (NULL, &desc);
+  comp = FindNextComponent (NULL, &desc);
   if (comp == NULL) {
     aerror("Failed to start CoreAudio: AudioComponentFindNext returned NULL");
     return 0;
   }
 
   /* Open & initialize the default output audio unit */
-  result = AudioComponentInstanceNew (comp, &internal->outputAudioUnit);
+  result = OpenAComponent (comp, &internal->outputAudioUnit);
   if (result) {
     aerror("AudioComponentInstanceNew() error => %d\n",(int)result);
     return 0;
@@ -520,9 +521,9 @@
       return 0;
     }
 
-    status = AudioUnitUninitialize(internal->outputAudioUnit);
+    status = CloseComponent(internal->outputAudioUnit);
     if (status) {
-      awarn("AudioUnitUninitialize returned %d\n", (int)status);
+      awarn("CloseComponent returned %d\n", (int)status);
       return 0;
     }
   }else
