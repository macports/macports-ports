--- src/unix-dll.mak.orig	Thu Jan 16 17:49:05 2003
+++ src/unix-dll.mak	Wed Oct 22 21:08:46 2003
@@ -47,12 +47,12 @@
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
 
@@ -76,7 +76,7 @@
 
 # ------------------------- Recursive make targets ------------------------- #
 
-SODEFS=LDFLAGS='$(LDFLAGS) $(CFLAGS_SO) -shared -Wl,-soname,$(GS_SONAME_MAJOR)'\
+SODEFS=LDFLAGS='$(LDFLAGS) $(CFLAGS_SO) -dynamiclib -install_name $(prefix)/lib/$(GS_SONAME_MAJOR)'\
  GS_XE=$(BINDIR)/$(SOBINRELDIR)/$(GS_SONAME_MAJOR_MINOR)\
  STDIO_IMPLEMENTATION=c\
  DISPLAY_DEV=$(DD)$(SOOBJRELDIR)/display.dev\
