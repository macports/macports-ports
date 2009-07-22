--- configure.sh.orig	2009-07-22 13:10:44.000000000 -0700
+++ configure.sh	2009-07-22 13:10:52.000000000 -0700
@@ -228,11 +228,9 @@
 #	cp vobcopy.1 \$(MANDIR)/man1/vobcopy.1
 	install -d -m 755 \$(DESTDIR)/\$(BINDIR)
 	install -d -m 755 \$(DESTDIR)/\$(MANDIR)/man1
-	install -d -m 755 \$(DESTDIR)/\$(MANDIR)/de/man1
 	install -d -m 755 \$(DESTDIR)/\$(DOCDIR)
 	install -m 755 vobcopy \$(DESTDIR)/\$(BINDIR)/vobcopy
 	install -m 644 vobcopy.1 \$(DESTDIR)/\$(MANDIR)/man1/vobcopy.1
-	install -m 644 vobcopy.1.de \$(DESTDIR)/\$(MANDIR)/de/man1/vobcopy.1
 	install -m 644 COPYING Changelog README Release-Notes TODO \$(DESTDIR)/\$(DOCDIR)
 
 uninstall:
