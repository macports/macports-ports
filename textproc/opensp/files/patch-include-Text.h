--- include/Text.h.orig	Tue Feb 22 04:46:31 2000
+++ include/Text.h	Wed Jan  8 22:16:19 2003
@@ -52,6 +52,8 @@
 class SP_API Text {
 public:
   Text();
+  // Dummy Destructor
+  ~Text();
   void clear();
   void swap(Text &to);
   void addChar(Char c, const Location &);
