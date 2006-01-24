--- functions.h.old	2005-12-20 23:38:50.000000000 -0800
+++ functions.h	2005-12-20 23:39:28.000000000 -0800
@@ -44,7 +44,7 @@
 NSString *systemBundlePath(void);
 NSString *userBundlePath(void);
 
-void fillPopup(id popupButton, NSString *folder, NSString *ext, int removeIx );
+void fillPopup(NSPopUpButton *popupButton, NSString *folder, NSString *ext, int removeIx );
 NSDictionary *dictionaryFromFolder(NSString *folder, NSString *name);
 
 /* functions using base unit from 'unit' default */
