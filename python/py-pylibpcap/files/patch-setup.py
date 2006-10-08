$NetBSD: patch-aa,v 1.1.1.1 2005/08/10 13:51:01 drochner Exp $

--- setup.py.orig	2005-08-10 12:30:07.000000000 +0200
+++ setup.py
@@ -14,8 +14,8 @@ config_defines = [ ]
 
 # uncomment this line and comment out the next one if you want to build
 # pcap.c from the SWIG interface
-sourcefiles = ["mk-constants.py", "pcap.i"]
-# sourcefiles = ["pcap.c"]
+#sourcefiles = ["mk-constants.py", "pcap.i"]
+sourcefiles = ["pcap.c"]
 
 # if you are building against a non-installed version of libpcap,
 # specify its directory here, otherwise set this to None
