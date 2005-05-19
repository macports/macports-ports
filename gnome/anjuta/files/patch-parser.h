--- tagmanager/parse.h.org	2005-05-18 18:45:55.000000000 +0200
+++ tagmanager/parse.h	2005-05-18 19:04:22.000000000 +0200
@@ -67,7 +67,7 @@
 typedef parserDefinition* (parserDefinitionFunc) (void);
 
 typedef struct {
-    off_t start;	/* character index in line where match starts */
+    long start;	/* character index in line where match starts */
     size_t length;	/* length of match */
 } regexMatch;
 
