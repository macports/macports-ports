--- byterun/unix.c.orig	Mon Mar  1 13:06:47 2004
+++ byterun/unix.c	Mon Mar  1 13:06:54 2004
@@ -168,34 +168,52 @@
 #ifdef HAS_NSLINKMODULE
 /* Use MacOSX bundles */
 
-static char *dlerror_string = "No error";
+static char *dlerror_string = NULL;
 
 void * caml_dlopen(char * libname)
 {
   NSObjectFileImage image;
+  char* theMessage = NULL;
   NSObjectFileImageReturnCode retCode =
     NSCreateObjectFileImageFromFile(libname, &image);
+  if (dlerror_string != NULL)
+  {
+    free( dlerror_string );
+    dlerror_string = NULL;
+  }
   switch (retCode) {
   case NSObjectFileImageSuccess:
     dlerror_string = NULL;
     return (void*)NSLinkModule(image, libname, NSLINKMODULE_OPTION_BINDNOW
 			       | NSLINKMODULE_OPTION_RETURN_ON_ERROR);
   case NSObjectFileImageAccess:
-    dlerror_string = "cannot access this bundle"; break;
+    theMessage = "cannot access this bundle"; break;
   case NSObjectFileImageArch:
-    dlerror_string = "this bundle has wrong CPU architecture"; break;
+    theMessage = "this bundle has wrong CPU architecture"; break;
   case NSObjectFileImageFormat:
   case NSObjectFileImageInappropriateFile:
-    dlerror_string = "this file is not a proper bundle"; break;
+    theMessage = "this file is not a proper bundle"; break;
   default:
-    dlerror_string = "could not read object file"; break;
+    theMessage = "could not read object file"; break;
+  }
+  if (theMessage != NULL)
+  {
+    size_t theLength;
+    theLength = strlen( theMessage ) + strlen( libname ) + 4;
+  	  /* space, (, ), terminator */
+    dlerror_string = malloc(theLength);
+    (void) sprintf( dlerror_string, "%s (%s)", theMessage, libname );
   }
   return NULL;
 }
 
 void caml_dlclose(void * handle)
 {
-  dlerror_string = NULL;
+  if (dlerror_string != NULL)
+  {
+    free( dlerror_string );
+    dlerror_string = NULL;
+  }
   NSUnLinkModule((NSModule)handle, NSUNLINKMODULE_OPTION_NONE);
 }
 
@@ -204,7 +222,11 @@
   NSSymbol sym;
   char _name[1000] = "_";
   strncat (_name, name, 998);
-  dlerror_string = NULL;
+  if (dlerror_string != NULL)
+  {
+    free( dlerror_string );
+    dlerror_string = NULL;
+  }
   sym = NSLookupSymbolInModule((NSModule)handle, _name);
   if (sym != NULL) return NSAddressOfSymbol(sym);
   else return NULL;
