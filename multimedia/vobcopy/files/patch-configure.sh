--- configure.sh.orig	2009-06-08 14:58:28.000000000 -0500
+++ configure.sh	2011-12-27 15:16:26.000000000 -0600
@@ -153,7 +153,7 @@
   else
 	  LDFLAGS="LDFLAGS += -ldvdread -L$libs_dir/lib"
   fi	
-elif [ `uname -m` = x86_64 ]; then #for ia64/AMD64 libraries
+elif [ `uname -m` = x86_64 -a `uname -s` != Darwin ]; then #for ia64/AMD64 libraries
 	LDFLAGS="LDFLAGS += -ldvdread -L$libs_dir/lib64"
 else
 	LDFLAGS="LDFLAGS += -ldvdread -L$libs_dir/lib"
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
