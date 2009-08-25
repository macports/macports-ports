--- ctool.c.orig	2004-04-02 08:39:45.000000000 -0600
+++ ctool.c	2009-08-25 00:10:15.000000000 -0500
@@ -779,7 +779,7 @@
         safe_strlcat( kg_get_url, file_hash, sizeof( kg_get_url ) );
 
         curl_easy_setopt( curl, CURLOPT_URL, kg_get_url );
-        curl_easy_setopt( curl, CURLOPT_NOPROGRESS );
+        curl_easy_setopt( curl, CURLOPT_NOPROGRESS, 1 );
 
         response = curl_easy_perform( curl );
         curl_easy_cleanup( curl );
