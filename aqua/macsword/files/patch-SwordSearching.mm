--- src/Backend/SwordSearching.mm.orig	2008-08-29 18:40:52.000000000 +1000
+++ src/Backend/SwordSearching.mm	2010-10-26 05:31:36.000000000 +1100
@@ -253,7 +253,7 @@
 		
 		long mindex = 0;
 		if (vkcheck) {
-			mindex = vkcheck->NewIndex();
+			mindex = vkcheck->Index();
 		} else {
 			mindex = module->getKey()->Index();
 		}
