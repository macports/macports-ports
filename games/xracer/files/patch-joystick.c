--- src/joystick_generic.c.orig	Wed Dec 11 23:18:06 2002
+++ src/joystick_generic.c	Wed Dec 11 23:18:31 2002
@@ -23,7 +23,7 @@
 #include "xracer-log.h"
 
 /* Joystick device. */
-char *xrJoystickDevice = NULL;
+const char *xrJoystickDevice = 0;
 
 /* Program-level initializations. */
 void
