--- Source/AIInterfaceController.m.orig	2005-04-03 20:42:42.000000000 -0400
+++ Source/AIInterfaceController.m	2005-04-03 20:43:11.000000000 -0400
@@ -1001,7 +1001,8 @@
         //Add the label (with its spacing)
         [titleString appendAttributedString:labelAttribString];
 		[labelAttribString release];
-        [titleString appendAttributedString:[entryString addAttributes:entryDict range:NSMakeRange(0,[entryString length])]];
+        [entryString addAttributes:entryDict range:NSMakeRange(0,[entryString length])];
+        [titleString appendAttributedString:entryString];
     }
     return [titleString autorelease];
 }
