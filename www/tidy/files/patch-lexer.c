--- lexer.c.orig	Fri Aug  4 19:21:05 2000
+++ lexer.c	Thu Nov 15 21:44:03 2001
@@ -1517,8 +1517,10 @@
 
                     continue;
                 }
-                else if (c == '&' && mode != IgnoreMarkup)
-                    ParseEntity(lexer, mode);
+                else if (c == '&' && mode != IgnoreMarkup
+				&& !PreserveEntities) {
+               		ParseEntity(lexer, mode);
+		}
 
                 /* this is needed to avoid trimming trailing whitespace */
                 if (mode == IgnoreWhitespace)
@@ -2624,7 +2626,7 @@
                 seen_gt = yes;
         }
 
-        if (c == '&')
+        if (c == '&')	/* XXX: possibly need support for PreserveEntities */
         {
             AddCharToLexer(lexer, c);
             ParseEntity(lexer, null);
