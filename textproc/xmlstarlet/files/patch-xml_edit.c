--- src/xml_edit.c	2006-10-09 10:50:18.000000000 +0200
+++ src/xml_edit.c	2006-10-09 11:04:17.000000000 +0200
@@ -59,7 +59,8 @@
 typedef struct _edOptions {   /* Global 'edit' options */
     int noblanks;             /* Remove insignificant spaces from XML tree */
     int preserveFormat;       /* Preserve original XML formatting */
-    int omit_decl;            /* Ommit XML declaration line <?xml version="1.0"?> */
+    int omit_decl;            /* Omit XML declaration line <?xml version="1.0"?> */
+    int inplace;              /* Edit file inplace (no output on stdout) */
 } edOptions;
 
 typedef edOptions *edOptionsPtr;
@@ -119,13 +120,14 @@
 "  -P (or --pf)        - preserve original formatting\n"
 "  -S (or --ps)        - preserve non-significant spaces\n"
 "  -O (or --omit-decl) - omit XML declaration (<?xml ...?>)\n"
+"  -L (or --inplace)   - edit file inplace\n"
 "  -N <name>=<value>   - predefine namespaces (name without \'xmlns:\')\n"
 "                        ex: xsql=urn:oracle-xsql\n"
 "                        Multiple -N options are allowed.\n"
-"                        -N options must be last global options.\n"
-"  --help or -h        - display help\n\n";
+"                        -N options must be last global options.\n";
 
 static const char edit_usage_str_3[] =
+"  --help or -h        - display help\n\n"
 "where <action>\n"
 "  -d or --delete <xpath>\n"
 "  -i or --insert <xpath> -t (--type) elem|text|attr -n <name> -v (--value) <value>\n"
@@ -171,6 +173,7 @@
     ops->noblanks = 1;
     ops->omit_decl = 0;
     ops->preserveFormat = 0;
+    ops->inplace = 0;
 }
 
 /**
@@ -196,6 +199,10 @@
         {
             ops->omit_decl = 1;
         }
+        else if (!strcmp(argv[i], "-L") || !strcmp(argv[i], "--inplace"))
+        {
+            ops->inplace = 1;
+        }
         else if (!strcmp(argv[i], "--help") || !strcmp(argv[i], "-h") ||
                  !strcmp(argv[i], "-?") || !strcmp(argv[i], "-Z"))
         {
@@ -842,6 +849,54 @@
 }
 
 /**
+ *  Output document
+ */
+void
+edOutput(const char* filename, edOptions g_ops)
+{
+    xmlDocPtr doc = xmlParseFile(filename);
+
+    if (!doc)
+    {
+        edCleanupNSArr(ns_arr);
+        xmlCleanupParser();
+        xmlCleanupGlobals();
+        exit(2);
+    }
+
+    edProcess(doc, ops, ops_count);
+
+    /* Print out result */
+    if (!g_ops.omit_decl)
+    {
+        xmlSaveFormatFile(g_ops.inplace ? filename : "-", doc, 1);
+    }
+    else
+    {
+        int format = 1;
+        int ret = 0;
+        char *encoding = NULL;
+        xmlOutputBufferPtr buf = NULL;
+        xmlCharEncodingHandlerPtr handler = NULL;
+        buf = xmlOutputBufferCreateFilename(g_ops.inplace ? filename : "-", handler, 0);
+
+        if (doc->children != NULL)
+        {
+            xmlNodePtr child = doc->children;
+            while (child != NULL)
+            {
+                xmlNodeDumpOutput(buf, doc, child, 0, format, encoding);
+                xmlOutputBufferWriteString(buf, "\n");
+                child = child->next;
+            }
+        }
+        ret = xmlOutputBufferClose(buf);
+    }
+    
+    xmlFreeDoc(doc);
+}
+
+/**
  *  This is the main function for 'edit' option
  */
 int
@@ -1059,90 +1114,12 @@
 
     if (i >= argc)
     {
-        xmlDocPtr doc = xmlParseFile("-");
-
-        if (!doc)
-        {
-            edCleanupNSArr(ns_arr);
-            xmlCleanupParser();
-            xmlCleanupGlobals();
-            exit(2);
-        }
-
-        edProcess(doc, ops, ops_count);
-
-        /* Print out result */
-        if (!g_ops.omit_decl)
-        {
-            xmlSaveFormatFile("-", doc, 1);
-        }
-        else
-        {
-            int format = 1;
-            int ret = 0;
-            char *encoding = NULL;
-            xmlOutputBufferPtr buf = NULL;
-            xmlCharEncodingHandlerPtr handler = NULL;
-            buf = xmlOutputBufferCreateFile(stdout, handler);
-
-            if (doc->children != NULL)
-            {
-               xmlNodePtr child = doc->children;
-               while (child != NULL)
-               {
-                  xmlNodeDumpOutput(buf, doc, child, 0, format, encoding);
-                  xmlOutputBufferWriteString(buf, "\n");
-                  child = child->next;
-               }
-            }
-            ret = xmlOutputBufferClose(buf);
-        }
-        
-        xmlFreeDoc(doc);
+        edOutput("-", g_ops);
     }
     
     for (n=i; n<argc; n++)
     {
-        xmlDocPtr doc = xmlParseFile(argv[n]);
-
-        if (!doc)
-        {
-            edCleanupNSArr(ns_arr);
-            xmlCleanupParser();
-            xmlCleanupGlobals();
-            exit(2);
-        }
-
-        edProcess(doc, ops, ops_count);
-
-        /* Print out result */
-        if (!g_ops.omit_decl)
-        {
-            xmlSaveFormatFile("-", doc, 1);
-        }
-        else
-        {
-            int format = 1;
-            int ret = 0;
-            char *encoding = NULL;
-            xmlOutputBufferPtr buf = NULL;
-            xmlCharEncodingHandlerPtr handler = NULL;
-            buf = xmlOutputBufferCreateFile(stdout, handler);
-
-            if (doc->children != NULL)
-            {
-               xmlNodePtr child = doc->children;
-               while (child != NULL)
-               {
-                  xmlNodeDumpOutput(buf, doc, child, 0, format, encoding);
-                  xmlOutputBufferWriteString(buf, "\n");
-                  child = child->next;
-               }
-            }
-            ret = xmlOutputBufferClose(buf);
-        }
-        
-        xmlFreeDoc(doc);
+        edOutput(argv[n], g_ops);
     }
 
     edCleanupNSArr(ns_arr);

 	  	 
