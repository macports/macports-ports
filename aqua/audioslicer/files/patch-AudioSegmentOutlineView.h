--- AudioSegmentOutlineView.h.orig	2005-04-19 07:34:28.000000000 -0400
+++ AudioSegmentOutlineView.h	2005-04-19 07:34:32.000000000 -0400
@@ -45,5 +45,5 @@
 
 @interface NSObject (AudioSegmentOutlineViewDelegate)
 - (NSColor *)outlineView:(NSOutlineView *)view backgroundColorForRow:(int)rowIndex;
-- (void)outlineView:(NSOutlineView *)view keyDown:(NSEvent *)keyEvent;
+- (BOOL)outlineView:(NSOutlineView *)view keyDown:(NSEvent *)keyEvent;
 @end
