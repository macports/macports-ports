--- c_src/esdl_driver.c~	2005-07-17 22:46:26.000000000 -0700
+++ c_src/esdl_driver.c	2005-07-17 22:45:18.000000000 -0700
@@ -116,7 +116,9 @@
       // To get a Menu & a dock icon : 
       err = CPSGetCurrentProcess(&PSN);
       assert(!(err = CPSSetProcessName(&PSN,"ESDL")));
-      assert(!(err = CPSEnableForegroundOperation(&PSN,0x03,0x3C,0x2C,0x1103)));
+//      assert(!(err = CPSEnableForegroundOperation(&PSN,0x03,0x3C,0x2C,0x1103)));
+      err = TransformProcessType(&PSN, kProcessTransformToForegroundApplication);
+      assert(!err || (-50 == err));	// -50 == process already foreground
       assert(!(err = CPSSetFrontProcess(&PSN)));
 
       // Makes the SDL window respond to keyboard events (???)
