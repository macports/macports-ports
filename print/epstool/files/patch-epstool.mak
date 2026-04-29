--- src/epstool.mak.orig	2005-06-10 13:41:00.000000000 +0400
+++ src/epstool.mak	2006-12-29 23:39:11.000000000 +0300
@@ -45,10 +45,10 @@
 
 include $(SRCDIR)/common.mak
 
-EPSTOOL_ROOT=/usr/local
+EPSTOOL_ROOT=
 EPSTOOL_BASE=$(prefix)$(EPSTOOL_ROOT)
 EPSTOOL_DOCDIR=$(EPSTOOL_BASE)/share/doc/epstool-$(EPSTOOL_VERSION)
-EPSTOOL_MANDIR=$(EPSTOOL_BASE)/man
+EPSTOOL_MANDIR=$(EPSTOOL_BASE)/share/man
 EPSTOOL_BINDIR=$(EPSTOOL_BASE)/bin
 
 epstool: $(BD)epstool$(EXE)
