--- mk/base.mk.orig	Sat Jun 28 12:28:30 2003
+++ mk/base.mk	Sat Jun 28 12:28:55 2003
@@ -73,6 +73,10 @@
 INSTALL	= /usr/ucb/install
 endif # SunOS
 
+ifeq (${HOST_OS}, Darwin)
+BINGRP = admin
+endif # Darwin
+
 PREFIX ?= /usr/local
 BINDIR ?= ${PREFIX}/bin
 MANDIR ?= ${PREFIX}/man
