--- ifaddrlist.c.orig	2009-08-13 00:08:22.000000000 -0700
+++ ifaddrlist.c	2009-08-13 00:08:58.000000000 -0700
@@ -99,7 +99,7 @@
 	    ifc.ifc_len < sizeof(struct ifreq)) {
 		if (errno == EINVAL)
 			(void)sprintf(errbuf,
-			    "SIOCGIFCONF: ifreq struct too small (%d bytes)",
+			    "SIOCGIFCONF: ifreq struct too small (%lu bytes)",
 			    sizeof(ibuf));
 		else
 			(void)sprintf(errbuf, "SIOCGIFCONF: %s",
@@ -162,7 +162,7 @@
 		}
 
 		if (nipaddr >= MAX_IPADDR) {
-			(void)sprintf(errbuf, "Too many interfaces (%d)",
+			(void)sprintf(errbuf, "Too many interfaces (%lu)",
 			    MAX_IPADDR);
 			(void)close(fd);
 			return (-1);
