--- BitTorrent/defaultargs.py.orig	Mon Mar  7 04:56:08 2005
+++ BitTorrent/defaultargs.py	Thu Mar 10 22:15:36 2005
@@ -77,7 +77,7 @@
      'if nonzero, set the TOS option for peer connections to this value'),
     ('filesystem_encoding', '',
      "character encoding used on the local filesystem. If left empty, autodetected. Autodetection doesn't work under python versions older than 2.3"),
-    ('enable_bad_libc_workaround', 0,
+    ('enable_bad_libc_workaround', 1,
      'enable workaround for a bug in BSD libc that makes file reads very slow.'),
     ('tracker_proxy', '',
      'address of HTTP proxy to use for tracker connections'),
