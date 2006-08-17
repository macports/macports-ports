--- setup.py	2006-07-27 11:04:30.000000000 +0200
+++ setup.py	2006-08-18 00:56:44.000000000 +0200
@@ -477,7 +477,7 @@
 data_files = [
          ('share/linkchecker',
              ['config/linkcheckerrc', 'config/logging.conf', ]),
-         ('share/linkchecker/examples',
+         ('share/doc/linkchecker/examples',
              ['cgi-bin/lconline/leer.html.en',
               'cgi-bin/lconline/leer.html.de',
               'cgi-bin/lconline/index.html',
@@ -492,7 +492,7 @@
     data_files.append(('share/man/man1', ['doc/en/linkchecker.1']))
     data_files.append(('share/man/de/man1', ['doc/de/linkchecker.1']))
     data_files.append(('share/man/fr/man1', ['doc/fr/linkchecker.1']))
-    data_files.append(('share/linkchecker/examples',
+    data_files.append(('share/doc/linkchecker/examples',
               ['config/linkchecker-completion', 'config/linkcheck-cron.sh']))
 elif win_compiling:
     data_files.append(('share/linkchecker/doc',
