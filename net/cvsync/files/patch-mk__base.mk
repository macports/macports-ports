--- mk/base.mk.orig	2004-05-16 12:23:39.000000000 -0400
+++ mk/base.mk	2005-04-19 05:42:23.000000000 -0400
@@ -51,6 +51,8 @@
 endif # CYGWIN
 
 ifeq (${HOST_OS}, Darwin)
+_OSVER := $(shell /usr/bin/uname -r | cut -d. -f1)
+OSVER  ?= ${_OSVER}
 BINGRP	= admin
 endif # Darwin
 
@@ -100,8 +102,8 @@
 MANMODE?= 644
 
 INSTALL		?= /usr/bin/install
-INSTALL_BIN_OPTS?= -c -o ${BINOWN} -g ${BINGRP} -m ${BINMODE}
-INSTALL_MAN_OPTS?= -c -o ${BINOWN} -g ${BINGRP} -m ${MANMODE}
+INSTALL_BIN_OPTS?= -c -m ${BINMODE}
+INSTALL_MAN_OPTS?= -c -m ${MANMODE}
 
 CVSYNC_DEFAULT_CONFIG	?=
 CVSYNCD_DEFAULT_CONFIG	?=
