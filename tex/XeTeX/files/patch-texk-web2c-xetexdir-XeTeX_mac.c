--- texk/web2c/xetexdir/XeTeX_mac.c	2006-08-23 04:41:00.000000000 +0900
+++ XeTeX_mac.c	2006-12-07 14:18:58.000000000 +0900
@@ -43,7 +43,7 @@
 
 #undef input /* this is defined in texmfmp.h, but we don't need it and it confuses the carbon headers */
 #include <Carbon/Carbon.h>
-#include <Quicktime/Quicktime.h>
+#include <QuickTime/QuickTime.h>
 
 #include "TECkit_Engine.h"
 #include "XeTeX_ext.h"
