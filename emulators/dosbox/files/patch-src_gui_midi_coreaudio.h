--- src/gui/midi_coreaudio.h.orig	2009-05-26 04:44:46.000000000 +1000
+++ src/gui/midi_coreaudio.h	2009-09-28 09:18:05.000000000 +1000
@@ -17,6 +17,7 @@
  */
 
 #include <AudioToolbox/AUGraph.h>
+#include <CoreServices/CoreServices.h>
 
 // A macro to simplify error handling a bit.
 #define RequireNoErr(error)                                         \
