--- DBModeler/DefaultColumnProvider.h	2006/10/01 13:04:05	23694
+++ DBModeler/DefaultColumnProvider.h	2006/10/01 16:32:23	23695
@@ -26,9 +26,9 @@
 
 #include <EOModeler/EOModelerApp.h>
 
-NSMutableArray *DefaultAttributeColumns;
-NSMutableArray *DefaultEntityColumns;
-NSMutableArray *DefaultRelationshipColumns;
+extern NSMutableArray *DefaultAttributeColumns;
+extern NSMutableArray *DefaultEntityColumns;
+extern NSMutableArray *DefaultRelationshipColumns;
 
 @interface DefaultColumnProvider : NSObject <EOMColumnProvider>
 {
