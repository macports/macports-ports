--- Frameworks/Adium Framework/AIListObject.m.orig	2005-04-03 20:21:35.000000000 -0400
+++ Frameworks/Adium Framework/AIListObject.m	2005-04-03 20:21:42.000000000 -0400
@@ -331,7 +331,8 @@
     id      rootValue = [[adium preferenceController] preferenceForKey:inKey group:groupName];
     if (rootValue){
         if (returnArray){
-            return [returnArray addObject:rootValue];
+            [returnArray addObject:rootValue];
+            return returnArray;
         }else{
             return [NSArray arrayWithObject:rootValue];
         }
