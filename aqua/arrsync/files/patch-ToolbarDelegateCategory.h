--- ToolbarDelegateCategory.h.orig	2006-03-19 10:11:24.000000000 +1100
+++ ToolbarDelegateCategory.h	2012-10-26 04:44:33.000000000 +1100
@@ -24,10 +24,9 @@ adam[dot]gc[dot]watkins[at]gmail[dot]com
 #import "header.h"
 #import "mainUIController.h"
 
-@interface MainUIController (ToolbarDelegateCategory)
-
 NSToolbar * toolbar;
 
+@interface MainUIController (ToolbarDelegateCategory)
 
 - (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
     itemForItemIdentifier:(NSString *)itemIdentifier
