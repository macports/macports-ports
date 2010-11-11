--- src/plugins/contrib/HexEditor//HexEditPanel.cpp.orig	2010-05-22 12:20:13.000000000 +0200
+++ src/plugins/contrib/HexEditor//HexEditPanel.cpp	2010-11-11 09:59:58.000000000 +0100
@@ -1028,7 +1028,11 @@ void HexEditPanel::OnDrawAreaKeyDown(wxK
 
         default:
         {
+#if wxUSE_UNICODE
             m_ActiveView->PutChar( event.GetUnicodeKey() );
+#else
+            m_ActiveView->PutChar( event.GetKeyCode() & 0xFF );
+#endif
             break;
         }
     }
