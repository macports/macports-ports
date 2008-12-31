--- pmkcfg.sh.orig	2007-05-27 04:54:30.000000000 -0600
+++ pmkcfg.sh	2008-10-21 23:31:18.000000000 -0600
@@ -410,7 +410,7 @@
 fi
 
 mkf_sed 'BINDIR' '$(PREFIX)/bin'
-mkf_sed 'MANDIR' '$(PREFIX)/man'
+mkf_sed 'MANDIR' '$(PREFIX)/share/man'
 mkf_sed 'MAN1DIR' '$(MANDIR)/man1'
 mkf_sed 'MAN5DIR' '$(MANDIR)/man5'
 mkf_sed 'MAN8DIR' '$(MANDIR)/man8'
