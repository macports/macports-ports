--- CURLHandleSource/CURLHandle.m.orig	Mon Oct 18 15:35:43 2004
+++ CURLHandleSource/CURLHandle.m	Mon Oct 18 15:36:02 2004
@@ -12,8 +12,8 @@
 #define NSS(s) (NSString *)(s)
 #include <SystemConfiguration/SystemConfiguration.h>
 
-#warning # If you build with a curl that was built under 10.2, the result will not be 10.1-compatible.
-#warning # ... so For 10.1 compatibility, please build curl under 10.1.
+// #warning # If you build with a curl that was built under 10.2, the result will not be 10.1-compatible.
+// #warning # ... so For 10.1 compatibility, please build curl under 10.1.
 
 
 // Un-comment these to do some debugging things
@@ -358,10 +358,10 @@
 		[mPort setDelegate:self];
 
 #if 1
-#warning # this may be leaking ... there are two retains going on here.  Apple bug report #2885852, still open after TWO YEARS!
+// #warning # this may be leaking ... there are two retains going on here.  Apple bug report #2885852, still open after TWO YEARS!
 		[[NSRunLoop currentRunLoop] addPort:mPort forMode:(NSString *)kCFRunLoopCommonModes];
 #else
-#warning # This attempt to compensate for the leak causes crashes....
+// #warning # This attempt to compensate for the leak causes crashes....
 {
 			int oldCount = [mPort retainCount];
 			int newCount;
@@ -852,7 +852,7 @@
 
 - (NSString *)headerString
 {
-#warning We can't really assume a header encoding, trying 7-bit ASCII only.  Maybe there is some way to know?
+// #warning We can't really assume a header encoding, trying 7-bit ASCII only.  Maybe there is some way to know?
 
 	if (nil == mHeaderString)		// Has it not been initialized yet?
 	{
