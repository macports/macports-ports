--- src/audio/macosx/SDL_coreaudio.c.orig	2009-06-10 07:03:19.000000000 -0700
+++ src/audio/macosx/SDL_coreaudio.c	2009-07-16 17:22:21.000000000 -0700
@@ -23,9 +23,6 @@
 
 #include <CoreAudio/CoreAudio.h>
 #include <AudioUnit/AudioUnit.h>
-#ifdef AVAILABLE_MAC_OS_X_VERSION_10_5_AND_LATER
-#include <AudioUnit/AUNTComponent.h>
-#endif
 
 #include "SDL_audio.h"
 #include "../SDL_audio_c.h"
@@ -342,7 +339,7 @@
                                           scope, bus, &callback,
                                           sizeof(callback));
 
-            CloseComponent(this->hidden->audioUnit);
+            AudioComponentInstanceDispose(this->hidden->audioUnit);
             this->hidden->audioUnitOpened = 0;
         }
         SDL_free(this->hidden->buffer);
@@ -416,8 +413,8 @@
 {
     OSStatus result = noErr;
     AURenderCallbackStruct callback;
-    ComponentDescription desc;
-    Component comp = NULL;
+    AudioComponentDescription desc;
+    AudioComponent comp = NULL;
     UInt32 enableIO = 0;
     const AudioUnitElement output_bus = 0;
     const AudioUnitElement input_bus = 1;
@@ -430,20 +427,20 @@
         return 0;
     }
 
-    SDL_memset(&desc, '\0', sizeof(ComponentDescription));
+    SDL_memset(&desc, '\0', sizeof(AudioComponentDescription));
     desc.componentType = kAudioUnitType_Output;
     desc.componentSubType = kAudioUnitSubType_HALOutput;
     desc.componentManufacturer = kAudioUnitManufacturer_Apple;
 
-    comp = FindNextComponent(NULL, &desc);
+    comp = AudioComponentFindNext(NULL, &desc);
     if (comp == NULL) {
         SDL_SetError("Couldn't find requested CoreAudio component");
         return 0;
     }
 
     /* Open & initialize the audio unit */
-    result = OpenAComponent(comp, &this->hidden->audioUnit);
-    CHECK_RESULT("OpenAComponent");
+    result = AudioComponentInstanceNew(comp, &this->hidden->audioUnit);
+    CHECK_RESULT("AudioComponentInstanceNew");
 
     this->hidden->audioUnitOpened = 1;
 
