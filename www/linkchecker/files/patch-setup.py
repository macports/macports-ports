--- setup.py	Tue Mar 15 01:04:57 2005
+++ ../../setup.py	Tue Mar 15 20:23:02 2005
@@ -329,7 +329,7 @@
 data_files = [
          ('share/linkchecker',
              ['config/linkcheckerrc', 'config/logging.conf', ]),
-         ('share/linkchecker/examples',
+         ('share/doc/linkchecker/examples',
              ['cgi/lconline/leer.html.en', 'cgi/lconline/leer.html.de',
               'cgi/lconline/index.html', 'cgi/lconline/lc_cgi.html.en',
               'cgi/lconline/lc_cgi.html.de', 'cgi/lconline/check.js',
@@ -340,7 +340,7 @@
     data_files.append(('share/man/man1', ['doc/en/linkchecker.1']))
     data_files.append(('share/man/de/man1', ['doc/de/linkchecker.1']))
     data_files.append(('share/man/fr/man1', ['doc/fr/linkchecker.1']))
-    data_files.append(('share/linkchecker/examples',
+    data_files.append(('share/doc/linkchecker/examples',
               ['config/linkchecker-completion', 'config/linkcheck-cron.sh']))
 elif os.name == 'nt':
     data_files.append(('share/linkchecker/doc',
