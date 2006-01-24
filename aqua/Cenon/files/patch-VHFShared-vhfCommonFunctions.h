--- VHFShared/vhfCommonFunctions.h	2005-12-21 00:33:28.000000000 -0800
+++ VHFShared/vhfCommonFunctions.h	2005-12-21 00:31:49.000000000 -0800
@@ -38,13 +38,15 @@
 
 #include "types.h"
 
+#include <AppKit/AppKit.h>
+
 /* Timers used to automatically scroll when the mouse is
  * outside the drawing view and not moving.
  */
 #define StartTimer(inTimerLoop) if (!inTimerLoop) { [NSEvent startPeriodicEventsAfterDelay:0.1 withPeriod:0.01]; inTimerLoop=YES; }
 #define StopTimer(inTimerLoop) if (inTimerLoop) { [NSEvent stopPeriodicEvents]; inTimerLoop=NO; }
 
-void		sortPopup(id popupButton, int startIx);
+void		sortPopup(NSPopUpButton *popupButton, int startIx);
 
 NSString	*stringWithConvertedChars(NSString *string, NSDictionary *conversionDict);
 
