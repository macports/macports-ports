--- setup.py.org.py	2007-01-29 21:40:55.000000000 -0800
+++ setup.py	2007-05-12 22:34:15.000000000 -0700
@@ -58,6 +58,6 @@
 	  scripts = ['rdiff-backup', 'rdiff-backup-statistics'],
 	  data_files = [('share/man/man1', ['rdiff-backup.1',
 										'rdiff-backup-statistics.1']),
-					('share/doc/rdiff-backup-%s' % (version_string,),
-					 ['CHANGELOG', 'COPYING', 'README', 'FAQ.html'])])
+					('share/doc/rdiff-backup',
+					 ['CHANGELOG', 'COPYING', 'README', 'FAQ.html', 'examples.html'])])
 
