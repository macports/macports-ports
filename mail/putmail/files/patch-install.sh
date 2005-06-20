--- install.sh	2005-06-18 12:11:07.000000000 +0200
+++ install.sh.new	2005-06-20 17:16:18.000000000 +0200
@@ -1,9 +1,9 @@
 #!/usr/bin/env bash
 
-program_dest=/usr/local/bin
-i18n_dest=/usr/share/locale
-doc_dest=/usr/local/share/doc/putmail
-man_dest=/usr/local/share/man
+program_dest=__PREFIX__/bin
+i18n_dest=__PREFIX__/share/locale
+doc_dest=__PREFIX__/share/doc/putmail
+man_dest=__PREFIX__/share/man
 
 # Create directories if necessary
 if [ ! -e "$program_dest" ]; then
