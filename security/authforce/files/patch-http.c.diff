--- src/http.c.orig	2007-11-03 13:43:23.000000000 -0700
+++ src/http.c	2007-11-03 13:44:09.000000000 -0700
@@ -68,7 +68,9 @@ int submit(char *username, char *passwor
 		curl_easy_setopt(curl, CURLOPT_FAILONERROR, 1);
 		curl_easy_setopt(curl, CURLOPT_USERPWD, authstring);
 		curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1);
+#ifdef CURLOPT_MUTE
 		curl_easy_setopt(curl, CURLOPT_MUTE, 1);
+#endif
 		curl_easy_setopt(curl, CURLOPT_NOPROGRESS, 1);
 		curl_easy_setopt(curl, CURLOPT_USERAGENT, user_agent);
 		if (strcmp(proxy, "undef"))
