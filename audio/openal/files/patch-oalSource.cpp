--- oalSource.cpp	Fri Sep  3 00:39:31 2004
+++ oalSource.cpp.new	Tue Sep 21 22:58:59 2004
@@ -74,7 +74,7 @@
 // This build flag should be on if you do not have a copy of AudioUnitProperties.h that
 // defines the struct MixerDistanceParams and the constant kAudioUnitProperty_3DMixerDistanceParams
 
-#define MIXER_PARAMS_UNDEFINED 0
+#define MIXER_PARAMS_UNDEFINED 1
 
 #if MIXER_PARAMS_UNDEFINED
 typedef struct MixerDistanceParams {
@@ -1780,4 +1780,4 @@
 	mReadIndex = readIndex;
 	
 	return noErr;
-}
\ No newline at end of file
+}
