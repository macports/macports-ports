--- Text.h.orig Thu Sep 12 19:09:26 2002
+++ include/Text.h      Thu Sep 12 19:09:23 2002
@@ -52,6 +52,7 @@
 class SP_API Text {
 public:
   Text();
+  ~Text();
   void clear();
   void swap(Text &to);
   void addChar(Char c, const Location &);
