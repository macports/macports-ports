--- ext/socket/socket.c.orig	2008-06-05 23:02:57.000000000 -0700
+++ ext/socket/socket.c	2008-06-05 23:07:36.000000000 -0700
@@ -877,6 +877,14 @@
     }
     else if (FIXNUM_P(port)) {
 	snprintf(pbuf, len, "%ld", FIX2LONG(port));
+	/* It looks like getaddrinfo changed in Mac OS X 10.5.3 so that sending "0" 
+	 * as the argument for the port number makes it return EAI_NONAME
+	 * but feeding it a port number of NULL seems to do the trick.
+	 * RSD - 2008-06-05
+	 */ 
+	if (FIX2LONG(port) == 0) {
+		return "";
+	}
 	return pbuf;
     }
     else {
@@ -3572,6 +3580,14 @@
     else if (FIXNUM_P(port)) {
 	snprintf(pbuf, sizeof(pbuf), "%ld", FIX2LONG(port));
 	pptr = pbuf;
+	/* It looks like getaddrinfo changed in Mac OS X 10.5.3 so that sending "0" 
+	 * as the argument for the port number makes it return EAI_NONAME
+	 * but feeding it a port number of NULL seems to do the trick.
+	 * RSD - 2008-06-05
+	 */ 
+	if (FIX2LONG(port) == 0) {
+		pptr = NULL;
+	}
     }
     else {
 	strncpy(pbuf, StringValuePtr(port), sizeof(pbuf));
@@ -3697,7 +3713,15 @@
 	}
 	else if (FIXNUM_P(port)) {
 	    snprintf(pbuf, sizeof(pbuf), "%ld", NUM2LONG(port));
-	    pptr = pbuf;
+		pptr = pbuf;
+		/* It looks like getaddrinfo changed in Mac OS X 10.5.3 so that sending "0" 
+		 * as the argument for the port number makes it return EAI_NONAME
+		 * but feeding it a port number of NULL seems to do the trick.
+		 * RSD - 2008-06-05
+		 */ 
+		if (NUM2LONG(port) == 0) {
+			pptr = NULL;
+		}
 	}
 	else {
 	    strncpy(pbuf, StringValuePtr(port), sizeof(pbuf));
