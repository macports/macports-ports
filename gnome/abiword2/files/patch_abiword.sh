--- abiword.sh.orig	Wed Sep 24 14:34:33 2003
+++ abiword.sh	Wed Sep 24 14:34:25 2003
@@ -0,0 +1,14 @@
+#!/bin/sh
+# make symlinks in ~/.fonts for applettf .ttf files
+# if they are not already there.
+for file in @PREFIX@/lib/X11/fonts/applettf/*ttf; do
+    if [ ! -d ~/.fonts ]; then
+        mkdir ~/.fonts
+    fi
+    symlink=~/.fonts/`basename $file`
+    if [ -f $file ] && [ ! -L $symlink ] && [ ! -f $symlink ] ; then
+        ln -s $file $symlink
+    fi
+done
+# launch abiword
+@PREFIX@/bin/abiwordx $@
