--- core/vul/vul_psfile.h.orig	2015-06-21 14:19:35.000000000 +0300
+++ core/vul/vul_psfile.h	2015-06-21 19:29:35.000000000 +0300
@@ -37,7 +37,7 @@
 
   vul_psfile(char const* filename, bool debug_output=false);
   ~vul_psfile();
-  operator bool() { return (void*)output_filestream!=(void*)0; }
+  operator bool() { return !!output_filestream; }
 
   void set_paper_type(vul_psfile::paper_type type){printer_paper_type = type;}
   void set_paper_layout(vul_psfile::paper_layout layout) {printer_paper_layout = layout;}
