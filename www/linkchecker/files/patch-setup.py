--- setup.py	Tue Jan 11 13:04:34 2005
+++ setup.py.new	Tue Jan 11 23:20:17 2005
@@ -242,7 +242,7 @@
              ['share/locale/nl/LC_MESSAGES/linkchecker.mo']),
          ('share/linkchecker',
              ['config/linkcheckerrc', 'config/logging.conf', ]),
-         ('share/linkchecker/examples',
+         ('share/doc/linkchecker/examples',
              ['cgi/lconline/leer.html.en', 'cgi/lconline/leer.html.de',
               'cgi/lconline/index.html', 'cgi/lconline/lc_cgi.html.en',
               'cgi/lconline/lc_cgi.html.de', 'cgi/lconline/check.js',
@@ -253,10 +253,10 @@
     data_files.append(('share/man/man1', ['doc/en/linkchecker.1']))
     data_files.append(('share/man/de/man1', ['doc/de/linkchecker.1']))
     data_files.append(('share/man/fr/man1', ['doc/fr/linkchecker.1']))
-    data_files.append(('share/linkchecker/examples',
+    data_files.append(('share/doc/linkchecker/examples',
               ['config/linkchecker-completion', 'config/linkcheck-cron.sh']))
 elif os.name == 'nt':
-    data_files.append(('share/linkchecker/doc',
+    data_files.append(('share/doc/linkchecker',
              ['doc/documentation.html', 'doc/index.html',
               'doc/install.html', 'doc/index.html', 'doc/other.html',
               'doc/upgrading.html', 'doc/lc.css', 'doc/navigation.css',
