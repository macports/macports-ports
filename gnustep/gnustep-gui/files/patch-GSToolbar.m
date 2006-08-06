--- Source/GSToolbar.m.orig	2006-07-30 13:54:57.000000000 -0400
+++ Source/GSToolbar.m	2006-07-30 13:56:52.000000000 -0400
@@ -88,6 +88,12 @@
   
   return result;
 }
+
+- (id) objectWithValue: (id)value forKey: (NSString *)key
+{
+    return [[self objectsWithValue: value forKey: key] objectAtIndex: 0];
+}
+
 @end
 
 /* 
