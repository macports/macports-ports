--- Frameworks/PopplerKit/config.sh.orig	2007-04-29 10:13:37.000000000 -0400
+++ Frameworks/PopplerKit/config.sh	2007-04-29 10:16:15.000000000 -0400
@@ -87,5 +89,6 @@
 # we add -I/usr/X11R6/include for older FreeBSD version.
 echo "ADDITIONAL_INCLUDE_DIRS += -I/usr/X11R6/include" >> config.make
 echo "HAVE_CAIRO=${HAVE_CAIRO}" >>config.make
+echo "CXX=g++-mp-4.2" >> config.make
 
 exit 0
