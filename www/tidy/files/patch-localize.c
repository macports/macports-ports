--- localize.c.orig	Fri Aug  4 19:21:05 2000
+++ localize.c	Mon Nov 19 14:39:38 2001
@@ -8,6 +8,9 @@
   to localize HTML tidy.
 */
 
+#include <sys/types.h>
+#include <sys/stat.h>
+
 #include "platform.h"
 #include "html.h"
 
@@ -50,6 +53,16 @@
     tidy_out(fp, "Can't open \"%s\"\n", file);
 }
 
+int FileExists(const char *file)
+{
+    struct stat st;
+
+    if (stat(file, &st) < 0)
+        return (0);
+    else
+        return (1);
+}
+
 static void ReportTag(Lexer *lexer, Node *tag)
 {
     if (tag)
@@ -736,6 +749,7 @@
     tidy_out(out, "  -xml            use this when input is wellformed xml\n");
     tidy_out(out, "  -asxml          to convert html to wellformed xml\n");
     tidy_out(out, "  -slides         to burst into slides on h2 elements\n");
+    tidy_out(out, "  -preserve       to preserve entities from source file\n");
     tidy_out(out, "\n");
 
     tidy_out(out, "Character encodings\n");
