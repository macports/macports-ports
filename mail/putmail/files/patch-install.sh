--- install.sh	Tue Mar 15 14:18:19 2005
+++ ../../install.sh	Thu Mar 17 20:34:28 2005
@@ -1,8 +1,8 @@
 #!/usr/bin/env bash
 
-program_dest=/usr/local/bin
-i18n_dest=/usr/share/locale
-doc_dest=/usr/local/share/doc/putmail-`cat doc/VERSION`
+program_dest=__PREFIX__/bin
+i18n_dest=__PREFIX__/share/locale
+doc_dest=__PREFIX__/share/doc/putmail
 
 # Create directories if necessary
 if [ ! -e "$program_dest" ]; then
