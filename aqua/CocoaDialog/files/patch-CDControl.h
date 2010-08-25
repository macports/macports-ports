--- src/CDControl.h.orig	2006-01-01 11:31:16.000000000 +0000
+++ src/CDControl.h	2009-12-28 11:07:49.000000000 +0000
@@ -39,7 +39,7 @@
 @interface CDControl : NSObject <CDControlProtocol> {
 	CDOptions *_options;
 }
-- initWithOptions:(CDOptions *)options;
+- initWithOptionList:(CDOptions *)options;
 
 // You should override availableKeys if you want options local to your control
 - (NSDictionary *) availableKeys;
