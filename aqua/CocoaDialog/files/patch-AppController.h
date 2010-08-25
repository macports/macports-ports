--- src/AppController.h.orig	2006-01-01 10:15:08.000000000 +0000
+++ src/AppController.h	2009-12-28 11:04:34.000000000 +0000
@@ -24,6 +24,6 @@
 
 @interface AppController : NSObject {
 }
-- (CDControl *) chooseControl:(NSString *)runMode useOptions:options addExtraOptionsTo:(NSMutableDictionary *)extraOptions;
+- (CDControl *) chooseControl:(NSString *)runMode useOptions:(CDOptions *)options addExtraOptionsTo:(NSMutableDictionary *)extraOptions;
 
 @end
