--- ufraw.h.orig	2014-01-11 11:04:08.000000000 -0800
+++ ufraw.h	2014-01-11 11:04:54.000000000 -0800
@@ -41,6 +41,10 @@
 /* An impossible value for conf float values */
 #define NULLF -10000.0
 
+#ifdef __cplusplus
+extern "C" {
+#endif // __cplusplus
+
 /* Options, like auto-adjust buttons can be in 3 states. Enabled and disabled
  * are obvious. Apply means that the option was selected and some function
  * has to act accourdingly, before changing to one of the first two states */
@@ -78,10 +82,6 @@ extern UFName ufRawImage;
 extern UFName ufRawResources;
 extern UFName ufCommandLine;
 
-#ifdef __cplusplus
-extern "C" {
-#endif // __cplusplus
-
     UFObject *ufraw_image_new();
 #ifdef HAVE_LENSFUN
     UFObject *ufraw_lensfun_new();
