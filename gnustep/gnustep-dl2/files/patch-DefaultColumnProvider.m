--- DBModeler/DefaultColumnProvider.m.orig	2006-09-12 15:36:24.000000000 -0400
+++ DBModeler/DefaultColumnProvider.m	2006-10-02 09:26:59.000000000 -0400
@@ -46,8 +46,11 @@
 
 static DefaultColumnProvider *_sharedDefaultColumnProvider;
 static NSMutableDictionary *_aspectsAndKeys;
-/* todo make this a struct instead of an array */
-/*	object			key 			default */
+
+NSMutableArray *DefaultEntityColumns;
+NSMutableArray *DefaultAttributeColumns;
+NSMutableArray *DefaultRelationshipColumns;
+
 struct column_info {
   NSString *key;
   NSString *name;
