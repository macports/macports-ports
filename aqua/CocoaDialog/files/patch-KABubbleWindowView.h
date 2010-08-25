--- src/KABubbleWindowView.h.orig	2005-12-30 17:12:11.000000000 +0000
+++ src/KABubbleWindowView.h	2009-12-28 12:05:32.000000000 +0000
@@ -8,8 +8,8 @@
 	NSAttributedString *_text;
 	SEL _action;
 	id _target;
-	float _darkColorFloat[4];   // Cache these rather than
-	float _lightColorFloat[4];  // calculating over and over.
+	CGFloat _darkColorFloat[4];   // Cache these rather than
+	CGFloat _lightColorFloat[4];  // calculating over and over.
 	NSColor *_darkColor;
 	NSColor *_lightColor;
 	NSColor *_textColor;
@@ -24,8 +24,8 @@
 - (void) setLightColor:(NSColor *)color;
 - (void) setTextColor:(NSColor *)color;
 - (void) setBorderColor:(NSColor *)color;
-- (const float *) darkColorFloat; // returns { r, g, b, a }
-- (const float *) lightColorFloat; // returns { r, g, b, a }
+- (const CGFloat *) darkColorFloat; // returns { r, g, b, a }
+- (const CGFloat *) lightColorFloat; // returns { r, g, b, a }
 - (NSColor *) darkColor;
 - (NSColor *) lightColor;
 - (NSColor *) textColor;
