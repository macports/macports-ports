--- oalDevice.cpp	Fri Sep  3 00:39:31 2004
+++ ../../../oalDevice.cpp	Tue Sep 21 23:06:01 2004
@@ -60,6 +60,17 @@
 }
 #endif
 
+typedef struct MixerDistanceParams {
+	Float32     mReferenceDistance;
+	Float32     mMaxDistance;
+	Float32     mMaxAttenuation;
+} MixerDistanceParams;
+
+enum {
+	kAudioUnitProperty_3DMixerDistanceParams   = 3010
+};
+
+
 // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 // OALDevices
