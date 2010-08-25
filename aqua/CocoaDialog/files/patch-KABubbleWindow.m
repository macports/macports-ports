--- src/KABubbleWindow.m.orig	2005-12-30 10:50:44.000000000 +0000
+++ src/KABubbleWindow.m	2009-12-28 12:07:12.000000000 +0000
@@ -6,7 +6,7 @@
 @implementation KABubbleWindow
 
 - (id)initWithContentRect:(NSRect)contentRect
-				styleMask:(unsigned int)aStyle
+				styleMask:(NSUInteger)aStyle
 				  backing:(NSBackingStoreType)bufferingType
 					defer:(BOOL)flag {
 	
