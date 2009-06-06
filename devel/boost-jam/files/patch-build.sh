--- build.sh.orig	2008-11-28 19:28:30.000000000 -0800
+++ build.sh	2009-06-05 23:48:34.000000000 -0700
@@ -133,7 +133,7 @@
     ;;
 
     darwin)
-    BOOST_JAM_CC=cc
+    BOOST_JAM_CC=__CC__
     ;;
 
     intel-linux)
@@ -288,7 +288,7 @@
 fi
 if test -x "./bootstrap/jam0" ; then
     if test "${BJAM_UPDATE}" != "update" ; then
-        echo_run ./bootstrap/jam0 -f build.jam --toolset=$BOOST_JAM_TOOLSET "--toolset-root=$BOOST_JAM_TOOLSET_ROOT" clean
+        echo_run ./bootstrap/jam0 -d2 -f build.jam --toolset=$BOOST_JAM_TOOLSET "--toolset-root=$BOOST_JAM_TOOLSET_ROOT" clean
     fi
-    echo_run ./bootstrap/jam0 -f build.jam --toolset=$BOOST_JAM_TOOLSET "--toolset-root=$BOOST_JAM_TOOLSET_ROOT" "$@"
+    echo_run ./bootstrap/jam0 -d2 -f build.jam --toolset=$BOOST_JAM_TOOLSET "--toolset-root=$BOOST_JAM_TOOLSET_ROOT" "$@"
 fi
