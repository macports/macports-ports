--- install.sh	Sun Mar 20 21:09:21 2005
+++ install.sh.new	Sat Mar 26 20:58:44 2005
@@ -1,9 +1,9 @@
 #!/usr/bin/env bash
 
-program_dest=/usr/local/bin
-i18n_dest=/usr/share/locale
-doc_dest=/usr/local/share/doc/putmail-`cat doc/VERSION`
-man_dest=/usr/local/share/man
+program_dest=__PREFIX__/bin
+i18n_dest=__PREFIX__/share/locale
+doc_dest=__PREFIX__/share/doc/putmail
+man_dest=__PREFIX__/share/man
 
 # Create directories if necessary
 if [ ! -e "$program_dest" ]; then
