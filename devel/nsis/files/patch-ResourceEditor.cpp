--- Source/ResourceEditor.cpp.orig	Thu Mar  3 19:26:32 2005
+++ Source/ResourceEditor.cpp	Thu Mar  3 19:32:19 2005
@@ -49,12 +49,12 @@
 
   // Get dos header
   m_dosHeader = (PIMAGE_DOS_HEADER)m_pbPE;
-  if (m_dosHeader->e_magic != IMAGE_DOS_SIGNATURE)
+  if (SWAP_ENDIAN_INT16(m_dosHeader->e_magic) != IMAGE_DOS_SIGNATURE)
     throw runtime_error("PE file contains invalid DOS header");
 
   // Get NT headers
-  m_ntHeaders = (PIMAGE_NT_HEADERS)(m_pbPE + m_dosHeader->e_lfanew);
-  if (m_ntHeaders->Signature != IMAGE_NT_SIGNATURE)
+  m_ntHeaders = (PIMAGE_NT_HEADERS)(m_pbPE + SWAP_ENDIAN_INT32(m_dosHeader->e_lfanew));
+  if (SWAP_ENDIAN_INT32(m_ntHeaders->Signature) != IMAGE_NT_SIGNATURE)
     throw runtime_error("PE file missing NT signature");
 
   // No check sum support yet...
@@ -83,7 +83,7 @@
     }
 
     // Invalid section pointer (goes beyond the PE image)
-    if (sectionHeadersArray[i].PointerToRawData > (unsigned int)m_iSize)
+    if (SWAP_ENDIAN_INT32(sectionHeadersArray[i].PointerToRawData) > (unsigned int)m_iSize)
       throw runtime_error("Invalid section pointer");
   }
 
