--- setup.py	Mon Dec  6 21:27:44 2004
+++ setup.py.new	Tue Dec  7 22:55:33 2004
@@ -242,7 +242,7 @@
              ['share/locale/nl/LC_MESSAGES/linkchecker.mo']),
          ('share/linkchecker',
              ['config/linkcheckerrc', 'config/logging.conf', ]),
-         ('share/linkchecker/examples',
+         ('share/doc/linkchecker/examples',
              ['cgi/lconline/leer.html.en', 'cgi/lconline/leer.html.de',
               'cgi/lconline/index.html', 'cgi/lconline/lc_cgi.html.en',
               'cgi/lconline/lc_cgi.html.de', 'cgi/lconline/check.js',
@@ -253,7 +253,7 @@
     data_files.append(('share/man/man1', ['doc/en/linkchecker.1']))
     data_files.append(('share/man/de/man1', ['doc/de/linkchecker.de.1']))
     data_files.append(('share/man/fr/man1', ['doc/fr/linkchecker.fr.1']))
-    data_files.append(('share/linkchecker/examples',
+    data_files.append(('share/doc/linkchecker/examples',
               ['config/linkchecker-completion', 'config/linkcheck-cron.sh']))
 elif os.name == 'nt':
     data_files.append(('share/linkchecker/doc',
