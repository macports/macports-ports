--- mk/base.mk.orig	Sat Feb 12 01:35:04 2005
+++ mk/base.mk	Sat Feb 12 01:35:11 2005
@@ -100,8 +100,8 @@
 MANMODE?= 644
 
 INSTALL		?= /usr/bin/install
-INSTALL_BIN_OPTS?= -c -o ${BINOWN} -g ${BINGRP} -m ${BINMODE}
-INSTALL_MAN_OPTS?= -c -o ${BINOWN} -g ${BINGRP} -m ${MANMODE}
+INSTALL_BIN_OPTS?= -c -m ${BINMODE}
+INSTALL_MAN_OPTS?= -c -m ${MANMODE}
 
 CVSYNC_DEFAULT_CONFIG	?=
 CVSYNCD_DEFAULT_CONFIG	?=
