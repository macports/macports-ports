Index: qemu/vl.c
===================================================================
RCS file: /cvsroot/qemu/qemu/vl.c,v
retrieving revision 1.92
diff -u -r1.92 vl.c
--- vl.c	3 Aug 2004 22:09:30 -0000	1.92
+++ vl.c	24 Aug 2004 13:56:05 -0000
@@ -1343,6 +1343,38 @@
 #endif /* CONFIG_SLIRP */
 
 #if !defined(_WIN32)
+#ifdef __APPLE__
+
+static int tun_open(char *ifname, int ifname_size)
+{
+    int fd;
+    int i = 0;
+    char *dev;
+    char buf[20];
+    struct stat s;
+
+    while (1) {
+        snprintf(buf, 20, "/dev/tap%d", i);
+        fd = open(buf, O_RDWR);
+        if (fd < 0) {
+            if (errno != EBUSY) {
+                fprintf(stderr, "warning: could not open %s: no virtual network emulation\n", buf);
+                return -1;
+            }
+            i++;
+        } else
+            break;
+    }
+
+    fstat(fd, &s);
+    dev = devname(s.st_rdev, S_IFCHR);
+    pstrcpy(ifname, ifname_size, dev);
+
+    fcntl(fd, F_SETFL, O_NONBLOCK);
+    return fd;
+}
+
+#else /* not __APPLE__ */
 #ifdef _BSD
 static int tun_open(char *ifname, int ifname_size)
 {
@@ -1363,7 +1395,7 @@
     fcntl(fd, F_SETFL, O_NONBLOCK);
     return fd;
 }
-#else
+#else /* not _BSD */
 static int tun_open(char *ifname, int ifname_size)
 {
     struct ifreq ifr;
@@ -1389,6 +1421,7 @@
     return fd;
 }
 #endif
+#endif
 
 static void tun_send_packet(NetDriverState *nd, const uint8_t *buf, int size)
 {
