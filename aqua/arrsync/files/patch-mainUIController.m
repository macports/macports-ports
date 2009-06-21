--- mainUIController.m.orig	2009-06-20 21:01:08.000000000 -0700
+++ mainUIController.m	2009-06-20 21:01:40.000000000 -0700
@@ -72,9 +72,11 @@
 	
 	//[fileTableView registerForDraggedTypes: [NSArray arrayWithObject: NSFilenamesPboardType]];
 	
+#ifndef __LP64__
 	if(UnsanitySCR_CanInstall(NULL)) {
 		UnsanitySCR_Install(0);
 	}
+#endif /* !__LP64__ */
 }
 
 //Actions
