--- html.h.orig	Fri Aug  4 18:21:05 2000
+++ html.h	Sat Jul 20 16:20:55 2002
@@ -4,6 +4,8 @@
   See tidy.c for the copyright notice.
 */
 
+#include <sys/types.h>
+
 /* indentation modes */
 
 #define NO_INDENT      0
@@ -380,6 +382,7 @@
 
 void FatalError(char *msg);
 void FileError(FILE *fp, const char *file);
+int FileExists(const char *file);
 
 Node *GetToken(Lexer *lexer, uint mode);
 
@@ -758,6 +761,7 @@
 extern Bool Word2000;
 extern Bool Emacs;  /* sasdjb 01May00 GNU Emacs error output format */
 extern Bool LiteralAttribs;
+extern Bool PreserveEntities;
 
 /* Parser methods for tags */
 
