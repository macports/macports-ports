--- libmpcodecs/vd_qtvideo.c.orig	Tue Apr 13 08:48:31 2004
+++ libmpcodecs/vd_qtvideo.c	Wed Apr 28 01:18:36 2004
@@ -55,10 +55,13 @@
 static HMODULE handler;
 
 #ifdef USE_QTX_CODECS
+#ifndef MACOSX
 static    Component (*FindNextComponent)(Component prev,ComponentDescription* desc);
 static    OSErr (*GetComponentInfo)(Component prev,ComponentDescription* desc,Handle h1,Handle h2,Handle h3);
 static    long (*CountComponents)(ComponentDescription* desc);
+#endif
 static    OSErr (*InitializeQTML)(long flags);
+#ifndef MACOSX
 static    OSErr (*EnterMovies)(void);
 static    ComponentInstance (*OpenComponent)(Component c);
 static    ComponentResult (*ImageCodecInitialize)(ComponentInstance ci,
@@ -89,6 +92,7 @@
                                void *baseAddr,
                                long rowBytes); 
 static    OSErr           (*NewHandleClear)(Size byteCount);                          
+#endif
 #endif
 
 // to set/get/query special features/parameters
