--- libmpcodecs/ad_qtaudio.c.orig	Wed Mar 26 09:48:17 2003
+++ libmpcodecs/ad_qtaudio.c	Tue Dec 30 00:39:10 2003
@@ -29,6 +29,7 @@
 LIBAD_EXTERN(qtaudio)
 
 #ifdef USE_QTX_CODECS
+#ifndef MACOSX
 typedef struct OpaqueSoundConverter*    SoundConverter;
 typedef unsigned long                   OSType;
 typedef unsigned long                   UnsignedFixed;
@@ -43,6 +44,7 @@
     Byte *                          buffer;
     long                            reserved;
 }SoundComponentData;
+#endif
 
 typedef int (__cdecl* LPFUNC1)(long flag);
 typedef int (__cdecl* LPFUNC2)(const SoundComponentData *, const SoundComponentData *,SoundConverter *);
@@ -68,14 +70,18 @@
 
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
 
@@ -95,7 +101,7 @@
         printf("failed loading dll\n" );
 	return 1;
     }
-#if 1
+#ifndef MACOSX
     InitializeQTML = (LPFUNC1)GetProcAddress(qtml_dll,"InitializeQTML");
 	if ( InitializeQTML == NULL )
     {
