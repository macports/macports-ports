--- src/xercesc/util/Transcoders/MacOSUnicodeConverter/MacOSUnicodeConverter.cpp.orig	2005-04-16 16:36:46.000000000 -0400
+++ src/xercesc/util/Transcoders/MacOSUnicodeConverter/MacOSUnicodeConverter.cpp	2005-04-16 16:36:57.000000000 -0400
@@ -75,13 +75,13 @@
 // ---------------------------------------------------------------------------
 //  Local, const data
 // ---------------------------------------------------------------------------
-static const XMLCh MacOSUnicodeConverter::fgMyServiceId[] =
+const XMLCh MacOSUnicodeConverter::fgMyServiceId[] =
 {
     chLatin_M, chLatin_a, chLatin_c, chLatin_O, chLatin_S, chNull
 };
 
 
-static const XMLCh MacOSUnicodeConverter::fgMacLCPEncodingName[] =
+const XMLCh MacOSUnicodeConverter::fgMacLCPEncodingName[] =
 {
         chLatin_M, chLatin_a, chLatin_c, chLatin_O, chLatin_S, chLatin_L
     ,   chLatin_C, chLatin_P, chLatin_E, chLatin_c, chLatin_o, chLatin_d
