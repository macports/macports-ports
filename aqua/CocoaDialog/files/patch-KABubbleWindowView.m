--- src/KABubbleWindowView.m.orig	2005-12-30 17:24:27.000000000 +0000
+++ src/KABubbleWindowView.m	2009-12-28 12:04:45.000000000 +0000
@@ -5,11 +5,11 @@
 #import "KABubbleWindowView.h"
 
 // info needs to be a KABubbleWindowView with rgb+alpha set.
-void KABubbleShadeInterpolate( void *info, float const *inData, float *outData ) {
+void KABubbleShadeInterpolate( void *info, CGFloat const *inData, CGFloat *outData ) {
 	// These 2 will always return an array of 4 floats
-	const float *dark = [(KABubbleWindowView *)info darkColorFloat];
-	const float *light = [(KABubbleWindowView *)info lightColorFloat];
-	float a = inData[0];
+	const CGFloat *dark = [(KABubbleWindowView *)info darkColorFloat];
+	const CGFloat *light = [(KABubbleWindowView *)info lightColorFloat];
+	CGFloat a = inData[0];
 	int i = 0;
 
 	for( i = 0; i < 4; i++ )
@@ -151,7 +151,7 @@
 	[_darkColor release];
 	_darkColor = color;
 
-	float r, g, b, alpha;
+	CGFloat r, g, b, alpha;
 	NSColor *rgb = [_darkColor colorUsingColorSpaceName:@"NSCalibratedRGBColorSpace"];
 	[rgb getRed:&r green:&g blue:&b alpha:&alpha];
 	_darkColorFloat[0] = r;
@@ -163,7 +163,7 @@
 {
 	return _darkColor;
 }
-- (const float *) darkColorFloat
+- (const CGFloat *) darkColorFloat
 {
 	return _darkColorFloat;
 }
@@ -173,7 +173,7 @@
 	[_lightColor release];
 	_lightColor = color;
 
-	float r, g, b, alpha;
+	CGFloat r, g, b, alpha;
 	NSColor *rgb = [_lightColor colorUsingColorSpaceName:@"NSCalibratedRGBColorSpace"];
 	[rgb getRed:&r green:&g blue:&b alpha:&alpha];
 	_lightColorFloat[0] = r;
@@ -185,7 +185,7 @@
 {
 	return _lightColor;
 }
-- (const float *) lightColorFloat
+- (const CGFloat *) lightColorFloat
 {
 	return _lightColorFloat;
 }
