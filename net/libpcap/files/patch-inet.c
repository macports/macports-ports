diff -ru work/libpcap-0.9.5/inet.c work.newpatch/libpcap-0.9.5/inet.c
--- inet.c	2006-01-21 02:46:13.000000000 -0800
+++ inet.c	2007-03-29 21:59:38.000000000 -0700
@@ -144,7 +144,55 @@
 	 * on Solaris; we don't just omit loopback interfaces
 	 * becaue you *can* capture on loopback interfaces on some
 	 * OSes.
-	 */
+	 *
+	 * We do this check so that interfaces that are
+	 * supplied by the interface enumeration mechanism
+	 * we're using but that don't support packet capture
+	 * aren't included in the list.  Loopback interfaces
+	 * on Solaris are an example of this; we don't just
+	 * omit loopback interfaces on all platforms because
+	 * you *can* capture on loopback interfaces on some
+	 * OSes.
+	 *
+	 * On OS X, we don't do this check if the device
+	 * name begins with "wlt"; at least some versions
+	 * of OS X offer monitor mode capturing by having
+	 * a separate "monitor mode" device for each wireless
+	 * adapter, rather than by implementing the ioctls
+	 * that {Free,Net,Open,DragonFly}BSD provide.
+	 * Opening that device puts the adapter into monitor
+	 * mode, which, at least for some adapters, causes
+	 * them to deassociate from the network with which
+	 * they're associated.
+	 *
+	 * Instead, we try to open the corresponding "en"
+	 * device (so that we don't end up with, for users
+	 * without sufficient privilege to open capture
+	 * devices, a list of adapters that only includes
+	 * the wlt devices).
+	 */
+#ifdef __APPLE__
+	if (strncmp(name, "wlt", 3) == 0) {
+		char *en_name;
+		size_t en_name_len;
+
+		/*
+		 * Try to allocate a buffer for the "en"
+		 * device's name.
+		 */
+		en_name_len = strlen(name) - 1;
+		en_name = malloc(en_name_len + 1);
+		if (en_name == NULL) {
+			(void)snprintf(errbuf, PCAP_ERRBUF_SIZE,
+				"malloc: %s", pcap_strerror(errno));
+			return (-1);
+		}
+		strlcpy(en_name, "en", (en_name_len + 1));
+		strlcat(en_name, (name + 3), (en_name_len + 1));
+		p = pcap_open_live(en_name, 68, 0, 0, errbuf);
+		free(en_name);
+		} else
+#endif /* __APPLE */	
 	p = pcap_open_live(name, 68, 0, 0, errbuf);
 	if (p == NULL) {
 		/*
