--- lib/expat.h    Thu Jan 16 15:03:42 2003
+++ lib/expat.h    Wed May 21 11:38:14 2003
@@ -647,6 +647,32 @@
 /* Returns the last value set by XML_SetUserData or NULL. */
 #define XML_GetUserData(parser) (*(void **)(parser))
 
+/* Parses some input. Returns XML_STATUS_ERROR if a fatal error is
+   detected.  The last call to XML_Parse must have isFinal true; len
+   may be zero for this call (or any other).
+
+   The XML_Status enum gives the possible return values for the
+   XML_Parse and XML_ParseBuffer functions.  Though the return values
+   for these functions has always been described as a Boolean value,
+   the implementation, at least for the 1.95.x series, has always
+   returned exactly one of these values.  The preprocessor #defines
+   are included so this stanza can be added to code that still needs
+   to support older versions of Expat 1.95.x:
+
+   #ifndef XML_STATUS_OK 
+   #define XML_STATUS_OK    1
+   #define XML_STATUS_ERROR 0
+   #endif
+
+   Otherwise, the #define hackery is quite ugly and would have been dropped.
+*/
+enum XML_Status {
+  XML_STATUS_ERROR = 0,     
+#define XML_STATUS_ERROR XML_STATUS_ERROR
+  XML_STATUS_OK = 1
+#define XML_STATUS_OK XML_STATUS_OK
+};
+
 /* This is equivalent to supplying an encoding argument to
    XML_ParserCreate. On success XML_SetEncoding returns non-zero,
    zero otherwise.
@@ -712,32 +738,6 @@
 */
 XMLPARSEAPI(int)
 XML_GetIdAttributeIndex(XML_Parser parser);
-
-/* Parses some input. Returns XML_STATUS_ERROR if a fatal error is
-   detected.  The last call to XML_Parse must have isFinal true; len
-   may be zero for this call (or any other).
-
-   The XML_Status enum gives the possible return values for the
-   XML_Parse and XML_ParseBuffer functions.  Though the return values
-   for these functions has always been described as a Boolean value,
-   the implementation, at least for the 1.95.x series, has always
-   returned exactly one of these values.  The preprocessor #defines
-   are included so this stanza can be added to code that still needs
-   to support older versions of Expat 1.95.x:
-
-   #ifndef XML_STATUS_OK
-   #define XML_STATUS_OK    1
-   #define XML_STATUS_ERROR 0
-   #endif
-
-   Otherwise, the #define hackery is quite ugly and would have been dropped.
-*/
-enum XML_Status {
-  XML_STATUS_ERROR = 0,
-#define XML_STATUS_ERROR XML_STATUS_ERROR
-  XML_STATUS_OK = 1
-#define XML_STATUS_OK XML_STATUS_OK
-};
 
 XMLPARSEAPI(enum XML_Status)
 XML_Parse(XML_Parser parser, const char *s, int len, int isFinal);

