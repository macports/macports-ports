--- IO/vtkBMPReader.cxx.orig	2005-06-19 16:56:27.000000000 -0400
+++ IO/vtkBMPReader.cxx	2005-06-19 16:57:40.000000000 -0400
@@ -30,18 +30,6 @@
 #undef read
 #endif
 
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
-extern "C"
-{
-  void oft_initIO() 
-  {
-  extern void _ZNSt8ios_base4InitC4Ev();
-  _ZNSt8ios_base4InitC4Ev();
-  }
-}
-#endif
-
 vtkBMPReader::vtkBMPReader()
 {
   this->Colors = NULL;
@@ -504,11 +492,11 @@
         outPtr0 += outIncr[0];
         }
       // move to the next row in the file and data
-      self->GetFile()->seekg(self->GetFile()->tellg() + streamSkip0, ios::beg);
+      self->GetFile()->seekg(static_cast<long>(self->GetFile()->tellg()) + streamSkip0, ios::beg);
       outPtr1 += outIncr[1];
       }
     // move to the next image in the file and data
-    self->GetFile()->seekg(self->GetFile()->tellg() + streamSkip1, ios::beg);
+    self->GetFile()->seekg(static_cast<long>(self->GetFile()->tellg()) + streamSkip1, ios::beg);
     outPtr2 += outIncr[2];
     }
 
