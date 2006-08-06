--- Headers/Additions/GNUstepGUI/GSToolbar.h.orig	2006-07-30 13:51:20.000000000 -0400
+++ Headers/Additions/GNUstepGUI/GSToolbar.h	2006-07-30 13:53:38.000000000 -0400
@@ -145,6 +145,7 @@
 
 @interface NSArray (ObjectsWithValueForKey)
 - (NSArray *) objectsWithValue: (id)value forKey: (NSString *)key;
+- (id) objectWithValue: (id)value forKey: (NSString *)key;
 @end
 
 #endif /* _GNUstep_H_NSToolbar */
