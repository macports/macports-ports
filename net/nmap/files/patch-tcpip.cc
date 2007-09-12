--- tcpip.cc.b	2007-09-12 09:17:26.000000000 -0700
+++ tcpip.cc	2007-09-12 09:21:19.000000000 -0700
@@ -2691,9 +2691,10 @@
 	eth_t *ethsd = eth_open_cached(mydevs[numifaces].devname);
 	eth_addr_t ethaddr;
 
-	if (!ethsd) 
-	  fatal("%s: Failed to open ethernet interface (%s). A possible cause on BSD operating systems is running out of BPF devices (see http://seclists.org/lists/nmap-dev/2006/Jan-Mar/0014.html).", __FUNCTION__,
-		mydevs[numifaces].devname);
+	if (!ethsd) {
+		error("Warning: Unable to open interface %s -- skipping it.", mydevs[numifaces].devname); 
+		continue; 
+	}
 	if (eth_get(ethsd, &ethaddr) != 0) 
 	  fatal("%s: Failed to obtain MAC address for ethernet interface (%s)",
 		__FUNCTION__, mydevs[numifaces].devname);
