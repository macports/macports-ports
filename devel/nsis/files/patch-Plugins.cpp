--- Source/Plugins.cpp.orig	Thu Mar  3 19:25:22 2005
+++ Source/Plugins.cpp	Thu Mar  3 19:25:03 2005
@@ -160,7 +160,7 @@
       return;
     }
 
-    PIMAGE_NT_HEADERS NTHeaders = PIMAGE_NT_HEADERS(dlldata + PIMAGE_DOS_HEADER(dlldata)->e_lfanew);
+    PIMAGE_NT_HEADERS NTHeaders = PIMAGE_NT_HEADERS(dlldata + SWAP_ENDIAN_INT32(PIMAGE_DOS_HEADER(dlldata)->e_lfanew));
     if (NTHeaders->Signature == IMAGE_NT_SIGNATURE)
     {
       if (NTHeaders->FileHeader.Characteristics & IMAGE_FILE_DLL)
