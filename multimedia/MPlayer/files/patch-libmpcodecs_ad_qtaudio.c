--- libmpcodecs/ad_qtaudio.c.orig	Tue Apr 13 08:33:18 2004
+++ libmpcodecs/ad_qtaudio.c	Wed Apr 28 01:14:58 2004
@@ -30,6 +30,7 @@
 LIBAD_EXTERN(qtaudio)
 
 #ifdef USE_QTX_CODECS
+#ifndef MACOSX
 typedef struct OpaqueSoundConverter*    SoundConverter;
 typedef unsigned long                   OSType;
 typedef unsigned long                   UnsignedFixed;
@@ -44,6 +45,7 @@
     Byte *                          buffer;
     long                            reserved;
 }SoundComponentData;
+#endif
 
 typedef int (__cdecl* LPFUNC1)(long flag);
 typedef int (__cdecl* LPFUNC2)(const SoundComponentData *, const SoundComponentData *,SoundConverter *);
@@ -69,14 +71,18 @@
 
 static HINSTANCE qtml_dll;
 static LPFUNC1 InitializeQTML;
+#ifndef MACOSX
 static LPFUNC2 SoundConverterOpen;
 static LPFUNC3 SoundConverterClose;
+#endif
 static LPFUNC4 TerminateQTML;
+#ifndef MACOSX
 static LPFUNC5 SoundConverterSetInfo;
 static LPFUNC6 SoundConverterGetBufferSizes;
 static LPFUNC7 SoundConverterConvertBuffer;
 static LPFUNC8 SoundConverterEndConversion;
 static LPFUNC9 SoundConverterBeginConversion;
+#endif
 
 #define siDecompressionParams 2002876005 // siDecompressionParams = FOUR_CHAR_CODE('wave')
 
@@ -96,7 +102,7 @@
         mp_msg(MSGT_DECAUDIO,MSGL_ERR,"failed loading dll\n" );
 	return 1;
     }
-#if 1
+#ifndef MACOSX
     InitializeQTML = (LPFUNC1)GetProcAddress(qtml_dll,"InitializeQTML");
 	if ( InitializeQTML == NULL )
     {
