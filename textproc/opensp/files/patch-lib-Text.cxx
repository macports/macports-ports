--- lib/Text.cxx.orig	Tue Feb 22 04:46:32 2000
+++ lib/Text.cxx	Wed Jan  8 22:16:19 2003
@@ -17,6 +17,10 @@
 {
 }
 
+Text::~Text()
+{
+}
+
 void Text::addChar(Char c, const Location &loc)
 {
   if (items_.size() == 0
