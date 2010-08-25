--- src/CDControl.m.orig	2006-02-26 00:13:04.000000000 +0000
+++ src/CDControl.m	2009-12-28 11:07:58.000000000 +0000
@@ -23,7 +23,7 @@
 
 @implementation CDControl
 
-- initWithOptions:(CDOptions *)options
+- initWithOptionList:(CDOptions *)options
 {
 	self = [super init];
 	[self setOptions:options];
@@ -31,7 +31,7 @@
 }
 - init
 {
-	return [self initWithOptions:nil];
+	return [self initWithOptionList:nil];
 }
 
 - (CDOptions *) options
