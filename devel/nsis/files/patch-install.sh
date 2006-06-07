--- install.sh.orig	2006-06-06 14:11:20.000000000 -0700
+++ install.sh	2006-06-06 14:11:48.000000000 -0700
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/sh -x
 #
 # This script installs the NSIS compiler on Linux
 #
@@ -38,11 +38,11 @@
 TARGETDIR="${PREFIX}/lib/NSIS"
 
 # Create target directory
-install --directory --owner=$OWNER --group=$GROUP \
+install -d -o $OWNER -g $GROUP \
  "${INSTALL_PREFIX}${TARGETDIR}"
 
 # Now install all files in the supporting directories
-DIRS="Contrib Docs Examples Include Menu Plugins"
+DIRS="Contrib Docs Examples Include Plugins"
 for x in $DIRS
 do
    cp -r "$x" ${INSTALL_PREFIX}${TARGETDIR}
@@ -55,23 +55,23 @@
 find "${INSTALL_PREFIX}${TARGETDIR}" -name "CVS" -exec rm -rf {} \; &>/dev/null
 
 # Install executable
-install --preserve-timestamps --owner=$OWNER --group=$GROUP --mode=755 \
+install -o $OWNER -g $GROUP -m 755 \
  makensis "${INSTALL_PREFIX}${TARGETDIR}"
 
 # Install config file
-install --preserve-timestamps --owner=$OWNER --group=$GROUP --mode=644 \
+install -o $OWNER -g $GROUP -m 644 \
  nsisconf.nsh "${INSTALL_PREFIX}${TARGETDIR}"
 
 # Now create a script that runs the compiler
 # This script should be installed in somewhere in the $PATH
-tempfile=$(tempfile)
+tempfile=$(mktemp /tmp/makensis.XXXXXXXX)
 cat >"$tempfile" <<EOF
 #!/bin/sh
 # This script calls the makensis compiler in ${TARGETDIR}
 ${TARGETDIR}/makensis \$*
 EOF
 
-install -D --mode=755 --owner=$OWNER --group=$GROUP \
+install -o $OWNER -g $GROUP -m 755 \
  "$tempfile" "${INSTALL_PREFIX}${PREFIX}/bin/makensis"
 
 \rm -f "$tempfile"
