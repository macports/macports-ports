--- setup.py.org.py	2006-09-22 14:03:02.000000000 -0700
+++ setup.py	2007-01-19 00:53:39.000000000 -0800
@@ -70,14 +70,10 @@
 
 else:	# try some generic paths
 	include_dirs = [
-		'/usr/include', '/usr/local/include',
-		'/usr/include/freetds', '/usr/local/include/freetds',
-		'/usr/pkg/freetds/include'	# netbsd
+		'__PREFIX__/include', '__PREFIX__/include/freetds'
 	]
 	library_dirs = [
-		'/usr/lib', '/usr/local/lib',
-		'/usr/lib/freetds', '/usr/local/lib/freetds'
-		'/usr/pkg/freetds/lib'		# netbsd
+		'__PREFIX__/lib', '__PREFIX__/lib/freetds'
 	]
 	libraries = ["sybdb"]
 	data_files = []
