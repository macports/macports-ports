--- Source/Plugins.cpp.old	Thu Mar  3 16:33:07 2005
+++ Source/Plugins.cpp	Thu Mar  3 16:36:13 2005
@@ -120,6 +120,7 @@
   {
     unsigned char* dlldata    = 0;
     long           dlldatalen = 0;
+    long           exehdr = 0;
     bool           loaded     = false;
     char           dllName[1024];
     char           signature[1024];
@@ -160,7 +161,11 @@
       return;
     }
 
-    PIMAGE_NT_HEADERS NTHeaders = PIMAGE_NT_HEADERS(dlldata + PIMAGE_DOS_HEADER(dlldata)->e_lfanew);
+    /* Correct address for host system */
+    exehdr = PIMAGE_DOS_HEADER(dlldata)->e_lfanew;
+    FIX_ENDIAN_INT32_INPLACE(exehdr);
+    
+    PIMAGE_NT_HEADERS NTHeaders = PIMAGE_NT_HEADERS(dlldata + exehdr);
     if (NTHeaders->Signature == IMAGE_NT_SIGNATURE)
     {
       if (NTHeaders->FileHeader.Characteristics & IMAGE_FILE_DLL)
