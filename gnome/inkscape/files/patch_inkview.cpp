--- src/inkview.cpp.org	Thu Apr 15 18:27:27 2004
+++ src/inkview.cpp	Thu Apr 15 18:27:48 2004
@@ -57,9 +57,7 @@
 
 #include <iostream>
 
-#ifndef HAVE_BIND_TEXTDOMAIN_CODESET
 #define bind_textdomain_codeset(p,c)
-#endif
 
 struct _SPSlideShow {
     char **slides;
