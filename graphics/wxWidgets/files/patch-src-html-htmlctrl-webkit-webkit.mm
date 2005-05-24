--- src/html/htmlctrl/webkit/webkit.mm	2005-04-15 18:33:39.000000000 +0200
+++ src/html/htmlctrl/webkit/webkit.mm	2005-05-24 18:06:26.000000000 +0200
@@ -27,6 +27,7 @@
 #else
 #include "wx/mac/uma.h"
 #include <Carbon/Carbon.h>
+#include <WebKit/WebKit.h>
 #include <WebKit/HIWebView.h>
 #include <WebKit/CarbonUtils.h>
 #endif
@@ -154,6 +155,10 @@
     MacPostControlCreate(pos, size);
     HIViewSetVisible( m_peer->GetControlRef(), true );
     [m_webView setHidden:false];
+#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_3
+	if ( UMAGetSystemVersion() >= 0x1030 )
+    HIViewChangeFeatures( m_peer->GetControlRef() , kHIViewIsOpaque , 0 ) ;
+#endif
 #endif
 
     // Register event listener interfaces
@@ -363,14 +368,14 @@
 
     //printf("Carbon position x=%d, y=%d\n", GetPosition().x, GetPosition().y);
     if (IsShown())
-        [m_webView display];
+        [(WebView*)m_webView display];
     event.Skip();
 }
 
 void wxWebKitCtrl::MacVisibilityChanged(){
     bool isHidden = !IsControlVisible( m_peer->GetControlRef());
     if (!isHidden)
-        [m_webView display];
+        [(WebView*)m_webView display];
 
     [m_webView setHidden:isHidden];
 }
