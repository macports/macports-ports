--- work/BitTorrent-4.20.0/setup.py	2006-06-20 04:14:30.000000000 +0200
+++ setup.py	2006-06-23 18:14:44.000000000 +0200
@@ -59,7 +59,6 @@
 use_scripts = symlinks
 if sys.argv[1:2] == ['sdist'] or not case_sensitive_filesystem:
     use_scripts = scripts
-    extra_docs.append('BUILD.windows.txt')
 
 img_root, doc_root, locale_root = calc_unix_dirs()
 
