--- ../cdparanoia-0.9.8.orig/interface/osx_interface.c	Fri Apr  8 19:35:10 2005
+++ interface/osx_interface.c	Fri Apr  8 19:35:18 2005
@@ -26,7 +26,7 @@
   CFTypeRef str_bsd_path;
   char *result;
 
-  str_bsd_path = IORegistryEntryCreateCFProperty(media, CFSTR(kIOBSDName), kCFAllocatorDefault, 0);
+  str_bsd_path = IORegistryEntryCreateCFProperty(media, CFSTR(kIOBSDNameKey), kCFAllocatorDefault, 0);
 
   if(str_bsd_path == NULL) {
     return NULL;
@@ -70,7 +70,7 @@
     return -1;
   }
 
-  CFDictionarySetValue(classes_to_match, CFSTR(kIOMediaEjectable), kCFBooleanTrue);
+  CFDictionarySetValue(classes_to_match, CFSTR(kIOMediaEjectableKey), kCFBooleanTrue);
 
   kern_result = IOServiceGetMatchingServices(port, classes_to_match, &media_iterator);
   if (kern_result != KERN_SUCCESS) {
