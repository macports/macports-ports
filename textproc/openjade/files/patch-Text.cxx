--- Text.cxx.orig       Thu Sep 12 16:25:48 2002
+++ lib/Text.cxx    Thu Sep 12 16:20:30 2002
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
