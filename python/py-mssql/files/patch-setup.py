--- setup.py.orig	2009-02-05 07:11:49.000000000 +0900
+++ setup.py	2009-04-28 14:12:21.000000000 +0900
@@ -81,18 +81,10 @@
 
 else:	# try some generic paths
 	include_dirs = [
-		'/usr/local/include', '/usr/local/include/freetds',  # first local install
-		'/usr/include', '/usr/include/freetds',   # some generic Linux paths
-		'/usr/include/freetds_mssql',             # some versions of Mandriva 
-		'/usr/local/freetds/include',             # FreeBSD
-		'/usr/pkg/freetds/include'	              # NetBSD
+		'__PREFIX__/include', '__PREFIX__/include/freetds'
 	]
 	library_dirs = [
-		'/usr/local/lib', '/usr/local/lib/freetds',
-		'/usr/lib', '/usr/lib/freetds',
-		'/usr/lib/freetds_mssql', 
-		'/usr/local/freetds/lib',
-		'/usr/pkg/freetds/lib'
+		'__PREFIX__/lib', '__PREFIX__/lib/freetds'
 	]
 	libraries = [ "sybdb" ]   # on Mandriva you may have to change it to sybdb_mssql
 	data_files = []
