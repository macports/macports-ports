--- setup.py.orig	2008-09-06 12:55:07.000000000 +0200
+++ setup.py	2008-09-29 08:45:11.000000000 +0200
@@ -63,7 +63,7 @@
       author_email="zero-install-devel@lists.sourceforge.net",
       url="http://0install.net",
       scripts=['0launch', '0alias', '0store', '0store-secure-add', '0desktop'],
-      data_files = [('man/man1', ['0launch.1', '0alias.1', '0store-secure-add.1', '0store.1', '0desktop.1']),
+      data_files = [('share/man/man1', ['0launch.1', '0alias.1', '0store-secure-add.1', '0store.1', '0desktop.1']),
 		    ('share/applications', ['applications/zeroinstall-add.desktop', 'applications/zeroinstall-manage.desktop']),
 		    ('share/desktop-directories', ['applications/zeroinstall.directory']),
 		    ('share/pixmaps', ['applications/zeroinstall-zero2desktop.png'])],
