--- setup.py.orig	2007-07-21 12:31:32.000000000 +0200
+++ setup.py	2007-10-15 14:32:24.000000000 +0200
@@ -38,7 +38,7 @@
       author_email="zero-install-devel@lists.sourceforge.net",
       url="http://0install.net",
       scripts=['0launch', '0alias', '0store', '0store-secure-add'],
-      data_files = [('man/man1', ['0launch.1', '0alias.1', '0store-secure-add.1', '0store.1']),
+      data_files = [('share/man/man1', ['0launch.1', '0alias.1', '0store-secure-add.1', '0store.1']),
       		    ('share/applications', ['applications/zeroinstall-zero2desktop.desktop']),
       		    ('share/pixmaps', ['applications/zeroinstall-zero2desktop.png'])],
       license='LGPL',
