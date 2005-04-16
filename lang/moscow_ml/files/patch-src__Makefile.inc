--- src/Makefile.inc.orig	Mon Jan 19 10:03:37 2004
+++ src/Makefile.inc	Sun Dec 26 14:53:49 2004
@@ -2,7 +2,7 @@
 
 # Where to install stuff
 
-MOSMLHOME=${HOME}/mosml
+MOSMLHOME=$(DESTDIR)__PREFIX__
 
 # Various utility programs
 INSTALL_PROGRAM=cp
@@ -29,9 +29,9 @@
 
 # For Linux (x86 or Alpha), use:
 # ------------------------------
-CPP=/lib/cpp -P -traditional -Dunix -Umsdos
+CPP=cpp -P -traditional -Dunix -Umsdos
 STRIP=strip
-LD=gcc -rdynamic
+LD=gcc
 DYNLD=ld -shared
 
 # For Cygwin 20.1, use:
@@ -114,10 +114,10 @@
 # DOCDIR contains documentation
 
 BINDIR=${MOSMLHOME}/bin
-LIBDIR=${MOSMLHOME}/lib
-INCDIR=${MOSMLHOME}/include
-DOCDIR=${MOSMLHOME}/doc
-TOOLDIR=${MOSMLHOME}/tools
+LIBDIR=${MOSMLHOME}/lib/moscow_ml
+INCDIR=${MOSMLHOME}/include/moscow_ml
+DOCDIR=${MOSMLHOME}/share/moscow_ml/doc
+TOOLDIR=${MOSMLHOME}/libexec/moscow_ml
 # LIBDIR=${MOSMLHOME}/lib/moscow_ml
 # TOOLDIR=${MOSMLHOME}/libexec/moscow_ml
 
