--- lib/http_ntlm.c.orig	Tue Dec  7 18:09:41 2004
+++ lib/http_ntlm.c	Wed Feb 23 14:06:35 2005
@@ -103,7 +103,6 @@
     header++;
 
   if(checkprefix("NTLM", header)) {
-    unsigned char buffer[256];
     header += strlen("NTLM");
 
     while(*header && isspace((int)*header))
@@ -123,8 +122,12 @@
          (40)    Target Information  (optional) security buffer(*)
          32 (48) start of data block
       */
+      size_t size;
+      unsigned char *buffer = (unsigned char *)malloc(strlen(header));
+      if (buffer == NULL)
+        return CURLNTLM_BAD;
 
-      size_t size = Curl_base64_decode(header, (char *)buffer);
+      size = Curl_base64_decode(header, (char *)buffer);
 
       ntlm->state = NTLMSTATE_TYPE2; /* we got a type-2 */
 
@@ -134,6 +137,7 @@
 
       /* at index decimal 20, there's a 32bit NTLM flag field */
 
+      free(buffer);
     }
     else {
       if(ntlm->state >= NTLMSTATE_TYPE1)
