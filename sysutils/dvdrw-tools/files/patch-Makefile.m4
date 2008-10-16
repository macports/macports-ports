--- Makefile.m4.orig	2006-09-24 11:55:19.000000000 -0600
+++ Makefile.m4	2007-04-03 14:32:25.000000000 -0600
@@ -30,8 +30,8 @@
 # to install set-root-uid, `make BIN_MODE=04755 install'...
 BIN_MODE?=0755
 install:	dvd+rw-tools
-	install -o root -m $(BIN_MODE) $(CHAIN) /usr/bin
-	install -o root -m 0644 growisofs.1 /usr/share/man/man1
+	install -m $(BIN_MODE) $(CHAIN) $(DESTDIR)@@PREFIX@@/bin
+	install -m 0644 growisofs.1 $(DESTDIR)@@PREFIX@@/share/man/man1
 ])
 
 ifelse(OS,MINGW32,[
