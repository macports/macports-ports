--- url_handler.sh.orig	Tue Jul  4 03:14:30 2000
+++ url_handler.sh	Wed Aug 22 10:42:49 2001
@@ -1,4 +1,4 @@
-#! /bin/bash
+#! /bin/sh
 
 #   Copyright (c) 1998  Martin Schulze <joey@debian.org>
 #   Slightly modified by Luis Francisco Gonzalez <luisgh@debian.org>
@@ -28,11 +28,11 @@
 # VT: Launch in the same terminal
 
 # The lists of programs to be executed are
-https_prgs="/usr/X11R6/bin/netscape:XW /usr/bin/lynx:XT"
-http_prgs="/usr/bin/lynx:XT /usr/X11R6/bin/netscape:XW"
-mailto_prgs="/usr/bin/mutt:VT /usr/bin/elm:VT /usr/bin/pine:VT /usr/bin/mail:VT"
-gopher_prgs="/usr/bin/lynx:XT /usr/bin/gopher:XT"
-ftp_prgs="/usr/bin/lynx:XT /usr/bin/ncftp:XT"
+https_prgs="!!PREFIX!!/bin/netscape:XW !!PREFIX!!/bin/lynx:XT !!PREFIX!!/bin/w3m:XT"
+http_prgs="!!PREFIX!!/bin/netscape:XW !!PREFIX!!/bin/lynx:XT !!PREFIX!!/bin/w3m:XT !!PREFIX!!/bin/links:XT"
+mailto_prgs="!!PREFIX!!/bin/mutt:VT !!PREFIX!!/bin/elm:VT !!PREFIX!!/bin/pine:VT /usr/bin/mail:VT"
+gopher_prgs="!!PREFIX!!/bin/lynx:XT !!PREFIX!!/bin/gopher:XT"
+ftp_prgs="!!PREFIX!!/bin/lynx:XT !!PREFIX!!/bin/ncftp2:XT !!PREFIX!!/bin/ncftp3:XT !!PREFIX!!/bin/ncftp:XT"
 
 # Program used as an xterm (if it doesn't support -T you'll need to change
 # the command line in getprg)
@@ -42,7 +42,7 @@
 ###########################################################################
 # Change bellow this at your own risk
 ###########################################################################
-function getprg()
+getprg()
 {
     local ele tag prog
 
