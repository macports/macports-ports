--- oalDevice.h	Wed Jan 19 02:30:15 2005
+++ ../../../oalDevice.h	Mon Mar 21 16:13:17 2005
@@ -219,3 +219,16 @@
 };
 
 #endif
+
+#ifndef OD_MIXER_DEFINED
+#define OD_MIXER_DEFINED 1
+typedef struct MixerDistanceParams {
+	Float32     mReferenceDistance;
+	Float32     mMaxDistance;
+	Float32     mMaxAttenuation;
+} MixerDistanceParams;
+
+enum {
+	kAudioUnitProperty_3DMixerDistanceParams   = 3010
+};
+#endif
