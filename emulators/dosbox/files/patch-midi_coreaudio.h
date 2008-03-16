--- src/gui/midi_coreaudio.h.orig	2007-12-10 20:52:24.000000000 +0000
+++ src/gui/midi_coreaudio.h	2007-12-10 20:52:42.000000000 +0000
@@ -17,6 +17,7 @@
  */
 
 #include <AudioUnit/AudioUnit.h>
+#include <AudioUnit/AUNTComponent.h>
 
 class MidiHandler_coreaudio : public MidiHandler {
 private:
