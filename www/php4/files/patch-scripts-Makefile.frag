--- scripts/Makefile.frag	2005-01-20 02:43:19.000000000 +0100
+++ scripts/Makefile.frag	2005-07-11 14:25:04.000000000 +0200
@@ -3,8 +3,8 @@
 # Build environment install
 #
 
-phpincludedir = $(includedir)/php
-phpbuilddir = $(prefix)/lib/php/build
+phpincludedir = $(includedir)/php4
+phpbuilddir = $(prefix)/lib/php4/build
 
 BUILD_FILES = \
 	scripts/phpize.m4 \
