--- IO/vtkImageReader.cxx.orig	2005-06-19 15:41:16.000000000 -0400
+++ IO/vtkImageReader.cxx	2005-06-19 15:42:22.000000000 -0400
@@ -366,7 +366,7 @@
       // if that happens, store the value in correction and apply later
       if (filePos + streamSkip0 >= 0)
         {
-        self->GetFile()->seekg(self->GetFile()->tellg() + streamSkip0, ios::beg);
+        self->GetFile()->seekg(static_cast<long>(self->GetFile()->tellg()) + streamSkip0, ios::beg);
         correction = 0;
         }
       else
@@ -376,7 +376,7 @@
       outPtr1 += outIncr[1];
       }
     // move to the next image in the file and data
-    self->GetFile()->seekg(self->GetFile()->tellg() + streamSkip1 + correction, 
+    self->GetFile()->seekg(static_cast<long>(self->GetFile()->tellg()) + streamSkip1 + correction, 
                       ios::beg);
     outPtr2 += outIncr[2];
     }
