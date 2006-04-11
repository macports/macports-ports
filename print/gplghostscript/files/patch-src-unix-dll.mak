--- src/unix-dll.mak.orig	2005-05-15 18:49:29.000000000 -0400
+++ src/unix-dll.mak	2005-05-15 18:50:55.000000000 -0400
@@ -45,12 +45,12 @@
 GSSOX=$(BINDIR)/$(SOBINRELDIR)/$(GSSOX_XENAME)
 
 # shared library
-GS_SONAME=lib$(GS).so
-GS_SONAME_MAJOR=$(GS_SONAME).$(GS_VERSION_MAJOR)
-GS_SONAME_MAJOR_MINOR= $(GS_SONAME).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR)
+GS_SONAME=lib$(GS).dylib
+GS_SONAME_MAJOR=lib$(GS).$(GS_VERSION_MAJOR).dylib
+GS_SONAME_MAJOR_MINOR=lib$(GS).$(GS_VERSION_MAJOR).$(GS_VERSION_MINOR).dylib
 GS_SO=$(BINDIR)/$(GS_SONAME)
-GS_SO_MAJOR=$(GS_SO).$(GS_VERSION_MAJOR)
-GS_SO_MAJOR_MINOR=$(GS_SO_MAJOR).$(GS_VERSION_MINOR)
+GS_SO_MAJOR=$(BINDIR)/$(GS_SONAME_MAJOR)
+GS_SO_MAJOR_MINOR=$(BINDIR)/$(GS_SONAME_MAJOR_MINOR)
 
 # Shared object is built by redefining GS_XE in a recursive make.
 
@@ -74,7 +74,7 @@
 
 # ------------------------- Recursive make targets ------------------------- #
 
-SODEFS=LDFLAGS='$(LDFLAGS) $(CFLAGS_SO) -shared -Wl,-soname=$(GS_SONAME_MAJOR)'\
+SODEFS=LDFLAGS='$(LDFLAGS) $(CFLAGS_SO) -unexported_symbols_list @@FILESPATH@@/unexported_symbols_list -dynamiclib -install_name $(prefix)/lib/$(GS_SONAME_MAJOR)'\
  GS_XE=$(BINDIR)/$(SOBINRELDIR)/$(GS_SONAME_MAJOR_MINOR)\
  STDIO_IMPLEMENTATION=c\
  DISPLAY_DEV=$(DD)$(SOOBJRELDIR)/display.dev\
