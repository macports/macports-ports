--- wap11gui/wap11config.cpp.orig	Fri Feb  6 20:10:58 2004
+++ wap11gui/wap11config.cpp	Fri Feb  6 20:16:43 2004
@@ -549,10 +549,10 @@
 {
   char s[16];
   sprintf(s, "%d.%d.%d.%d",
-          (unsigned char)(ipa&0xff),
-          (unsigned char)((ipa&0xff00)>>8),
+          (unsigned char)((ipa&0xff000000)>>24),
           (unsigned char)((ipa&0xff0000)>>16),
-          (unsigned char)((ipa&0xff000000)>>24));
+          (unsigned char)((ipa&0xff00)>>8),
+          (unsigned char)(ipa&0xff));
   std::string ret(s);
   return ret;
 }
