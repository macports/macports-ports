--- aclocal.m4.orig	Sat Jul 19 12:03:13 2003
+++ aclocal.m4	Thu Feb  5 16:21:21 2004
@@ -7445,6 +7445,10 @@
 	if test ! -z "$DYN_LOADER" ; then
 		ost_cv_dynloader=yes
 		AC_DEFINE(HAVE_MODULES)
+		AC_CHECK_HEADERS(mach-o/dyld.h,[
+			MODULE_FLAGS=\
+"-dynamic -bundle -undefined suppress -flat_namespace -read_only_relocs suppress"
+			AC_DEFINE(HAVE_MACH_DYLD)])
 	else
 		AC_CHECK_LIB(c, dlopen, [
 			ost_cv_dynloader=yes
