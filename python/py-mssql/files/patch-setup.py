--- setup.py	2006-02-23 01:37:52.000000000 +0100
+++ setup.py	2006-03-03 09:44:38.000000000 +0100
@@ -23,14 +23,10 @@
 
 else:	# try some generic paths
 	include_dirs = [
-		'/usr/include', '/usr/local/include',
-		'/usr/include/freetds', '/usr/local/include/freetds',
-		'/usr/pkg/freetds/include'	# netbsd2
+		'__PREFIX__/include', '__PREFIX__/include/freetds'
 	]
 	library_dirs = [
-		'/usr/lib', '/usr/local/lib',
-		'/usr/lib/freetds', '/usr/local/lib/freetds'
-		'/usr/pkg/freetds/lib'		# netbsd2
+		'__PREFIX__/lib', '__PREFIX__/lib/freetds'
 	]
 	libraries = ["sybdb"]
 	data_files = []
