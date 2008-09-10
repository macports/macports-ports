--- setup.py.orig	Wed Jun 16 15:13:57 2004
+++ setup.py	Wed Jun 16 15:14:29 2004
@@ -75,7 +75,7 @@
 	  scripts = ['rdiff-backup', 'rdiff-backup-statistics'],
 	  data_files = [('share/man/man1', ['rdiff-backup.1',
 										'rdiff-backup-statistics.1']),
-					('share/doc/rdiff-backup-%s' % (version_string,),
-					 ['CHANGELOG', 'COPYING', 'README', 'FAQ.html'])],
+					('share/doc/rdiff-backup',
+					 ['CHANGELOG', 'COPYING', 'README', 'FAQ.html', 'examples.html'])],
 					**extra_options)
