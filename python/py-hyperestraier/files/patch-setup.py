--- setup.py.orig	2005-09-01 08:03:46.000000000 +0900
+++ setup.py	2006-03-23 23:39:56.000000000 +0900
@@ -7,9 +7,14 @@
 	s = os.popen(cmdline).read()
 	return re.findall(r'-l(\w+)', s)
 
+def get_dirs(cmdline):
+	return [os.popen(cmdline).read()[:-1]]
+
 module1 = Extension(
 			'_HyperEstraier',
-			sources = ['HyperEstraier.i'],
+			['HyperEstraier_wrap.cxx'],
+			include_dirs = get_dirs('estconfig --headdir'),
+			library_dirs = get_dirs('estconfig --libdir'),
 			libraries = get_libs('estconfig --libs') + ['stdc++'])
 
 setup(
