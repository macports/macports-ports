--- install.sh	Tue Dec 21 22:55:31 2004
+++ install.sh.new	Wed Dec 22 10:02:21 2004
@@ -1,8 +1,8 @@
 #! /bin/bash
 
-program_dest=/usr/local/bin
-i18n_dest=/usr/share/locale
-doc_dest=/usr/local/share/doc/putmail-`cat doc/VERSION`
+program_dest=__PREFIX__/bin
+i18n_dest=__PREFIX__/share/locale
+doc_dest=__PREFIX__/share/doc/putmail
 
 # Create directories if necessary
 if [ ! -e $program_dest ]; then
