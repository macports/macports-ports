--- lib/ftio.c.orig	Mon Oct  2 12:26:19 2006
+++ lib/ftio.c	Mon Oct  2 12:27:53 2006
@@ -2267,7 +2267,7 @@
         break;
 
       nleft -= nread;
-      (char*)ptr += nread;
+      ptr = (char *)ptr + nread;
   }
   return (nbytes - nleft);
 } /* readn */
@@ -2292,7 +2292,7 @@
       return(nwritten); /* error */
 
     nleft -= nwritten;
-    (char*)ptr += nwritten;
+    ptr = (char *)ptr + nwritten;
   }
   return(nbytes - nleft);
 } /* writen */
