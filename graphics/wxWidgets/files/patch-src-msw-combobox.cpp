--- src/msw/combobox.cpp	Sun Sep 19 17:06:09 2004
+++ combobox.cpp	Thu Nov 11 12:10:29 2004
@@ -254,6 +254,15 @@
             UnpackCtlColor(wParam, lParam, &nCtlColor, &hdc, &hwnd);
 
             return (WXLRESULT)OnCtlColor(hdc, hwnd, nCtlColor, nMsg, wParam, lParam);
+            
+        case CB_SETCURSEL:
+            // Selection was set with SetSelection.  Update the value too.
+            if (wParam < 0 || wParam > GetCount())
+                m_value = wxEmptyString;
+            else
+                m_value = GetString(wParam);
+            break;
+            
     }
 
     return wxChoice::MSWWindowProc(nMsg, wParam, lParam);
