--- http_client.c.orig	Wed Feb  2 03:52:25 2005
+++ http_client.c	Wed Feb  2 03:58:25 2005
@@ -50,6 +50,7 @@
 #include <stdio.h>
 #include <errno.h>
 #include <string.h>
+#include <netinet/in.h>
 
 #include "portability.h"
 #include "thread.h"
@@ -502,6 +503,17 @@
 
 }
 
+void HTTP_FreeHeaders(HTTP_Header **headersList) {
+    HTTP_Header *cur, *next;
+
+    cur = *headersList;
+    while (cur) {
+        next = cur->next;
+        free(cur);
+        cur = next;
+    }
+}
+
 HTTP_GetResult *HTTP_Client_Get(HTTP_Connection *connection,
                                 const char *path,
                                 const char *hash,
@@ -537,6 +549,8 @@
     httpStatusCode = HTTP_PassStandardHeaders(headersList,
                                               &httpContentLength);
 
+    HTTP_FreeHeaders(&headersList);
+
     if (httpStatusCode == 401) /* unauthorized */
     {
         /* need a way to report it to the app */
@@ -630,6 +644,8 @@
 
     httpStatusCode = HTTP_PassStandardHeaders(headersList,
                                               &httpContentLength);
+
+    HTTP_FreeHeaders(&headersList);
 
     if (httpStatusCode != 200)
     {
