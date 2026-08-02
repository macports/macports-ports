--- Makefile.m4.orig	2008-03-02 11:17:09.000000000 -0600
+++ Makefile.m4	2021-12-02 17:13:11.000000000 -0600
@@ -20,18 +20,20 @@
 #
 # Mac OS X section
 #
-CC	=gcc
-CFLAGS	+=$(WARN) -D__unix -O2
-CXX	=g++
-CXXFLAGS+=$(WARN) -D__unix -O2 -fno-exceptions
+CC	?=gcc
+CFLAGS	?=-O2
+CFLAGS	+=$(WARN) -D__unix
+CXX	?=g++
+CXXFLAGS?=-O2
+CXXFLAGS+=$(WARN) -D__unix -fno-exceptions
 LDLIBS	=-framework CoreFoundation -framework IOKit
 LINK.o	=$(LINK.cc)
 
 # to install set-root-uid, `make BIN_MODE=04755 install'...
 BIN_MODE?=0755
 install:	dvd+rw-tools
-	install -o root -m $(BIN_MODE) $(CHAIN) /usr/bin
-	install -o root -m 0644 growisofs.1 /usr/share/man/man1
+	install -m $(BIN_MODE) $(CHAIN) $(DESTDIR)@@PREFIX@@/bin
+	install -m 0644 growisofs.1 $(DESTDIR)@@PREFIX@@/share/man/man1
 ])
 
 ifelse(OS,MINGW32,[
