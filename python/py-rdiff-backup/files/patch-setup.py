--- setup.py.orig	Wed Jun 16 15:13:57 2004
+++ setup.py	Wed Jun 16 15:14:29 2004
@@ -57,6 +57,6 @@
 							   extra_link_args=lflags_arg)],
 	  scripts = ['rdiff-backup'],
 	  data_files = [('share/man/man1', ['rdiff-backup.1']),
-					('share/doc/rdiff-backup-%s' % (version_string,),
-					 ['CHANGELOG', 'COPYING', 'README', 'FAQ.html'])])
+					('share/doc/rdiff-backup',
+					 ['CHANGELOG', 'COPYING', 'README', 'FAQ.html', 'examples.html'])])
 
