--- flood_round_robin.c.orig	Wed Apr  7 11:59:12 2004
+++ flood_round_robin.c	Wed Apr  7 11:59:42 2004
@@ -903,7 +903,7 @@
 
     /* FIXME: This algorithm sucks.  I need to be shot for writing such 
      * atrocious code.  Grr.  */
-    cookieheader = strstr(resp->rbuf, "Set-Cookie: ");
+    cookieheader = strnstr(resp->rbuf, "Set-Cookie: ", resp->rbufsize);
     if (cookieheader)
     {
         /* Point to the value */
