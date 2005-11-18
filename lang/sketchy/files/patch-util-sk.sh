--- util/sk.sh	2005-07-26 10:11:57.000000000 +0200
+++ util/sk.sh	2005-11-19 00:11:19.000000000 +0100
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 B=""
-image="/usr/local/share/sketchy/sketchy.image"
+image="__PREFIX__/share/sketchy/sketchy.image"
 
 while [ "$1" != "" ]; do
 	case $1 in
