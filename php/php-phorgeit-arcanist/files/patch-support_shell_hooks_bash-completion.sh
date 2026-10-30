--- support/shell/hooks/bash-completion.sh.orig	2020-05-14 22:49:28 UTC
+++ support/shell/hooks/bash-completion.sh
@@ -1,9 +1,10 @@
 SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
-GENERATED_RULES_FILE="${SCRIPTDIR}/../rules/bash-rules.sh"
+GENERATED_RULES_FILE="%%PREFIX%%/%%PHP_DESTDIR%%/support/shell/rules/bash-rules.sh"
 
 # Try to generate the shell completion rules if they do not yet exist.
 if [ ! -f "${GENERATED_RULES_FILE}" ]; then
-  arc shell-complete --generate >/dev/null 2>/dev/null
+  %%PREFIX%%/%%PHP_DESTDIR%%/bin/arc \
+  	shell-complete --generate >/dev/null 2>/dev/null
 fi;
 
 # Source the shell completion rules.
