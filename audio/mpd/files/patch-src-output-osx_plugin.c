--- src/output/osx_plugin.c.orig	2009-09-11 00:11:55.000000000 -0500
+++ src/output/osx_plugin.c	2009-09-11 22:02:46.000000000 -0500
@@ -90,9 +90,9 @@
 
 	AudioOutputUnitStop(od->au);
 	AudioUnitUninitialize(od->au);
-	CloseComponent(od->au);
+	AudioComponentInstanceDispose(od->au);
 
	fifo_buffer_free(od->buffer);
 }
 
 static OSStatus
@@ -157,12 +157,12 @@
 osx_output_open(void *data, struct audio_format *audio_format, GError **error)
 {
 	struct osx_output *od = data;
-	ComponentDescription desc;
-	Component comp;
+	AudioComponentDescription desc;
+	AudioComponent comp;
 	AURenderCallbackStruct callback;
 	AudioStreamBasicDescription stream_description;
 	OSStatus status;
-	ComponentResult result;
+	OSStatus result;
 
 	if (audio_format->bits > 16)
 		audio_format->bits = 16;
@@ -173,14 +173,14 @@
 	desc.componentFlags = 0;
 	desc.componentFlagsMask = 0;
 
-	comp = FindNextComponent(NULL, &desc);
+	comp = AudioComponentFindNext(NULL, &desc);
 	if (comp == 0) {
 		g_set_error(error, osx_output_quark(), 0,
 			    "Error finding OS X component");
 		return false;
 	}
 
-	status = OpenAComponent(comp, &od->au);
+	status = AudioComponentInstanceNew(comp, &od->au);
 	if (status != noErr) {
 		g_set_error(error, osx_output_quark(), 0,
 			    "Unable to open OS X component: %s",
@@ -190,7 +190,7 @@
 
 	status = AudioUnitInitialize(od->au);
 	if (status != noErr) {
-		CloseComponent(od->au);
+		AudioComponentInstanceDispose(od->au);
 		g_set_error(error, osx_output_quark(), 0,
 			    "Unable to initialize OS X audio unit: %s",
 			    GetMacOSStatusCommentString(status));
@@ -206,7 +206,7 @@
 				      &callback, sizeof(callback));
 	if (result != noErr) {
 		AudioUnitUninitialize(od->au);
-		CloseComponent(od->au);
+		AudioComponentInstanceDispose(od->au);
 		g_set_error(error, osx_output_quark(), 0,
 			    "unable to set callback for OS X audio unit");
 		return false;
@@ -232,7 +232,7 @@
 				      sizeof(stream_description));
 	if (result != noErr) {
 		AudioUnitUninitialize(od->au);
-		CloseComponent(od->au);
+		AudioComponentInstanceDispose(od->au);
 		g_set_error(error, osx_output_quark(), 0,
 			    "Unable to set format on OS X device");
 		return false;
