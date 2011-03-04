--- gettext-1.05/Makefile.PL.orig	2008-12-12 11:20:06.000000000 -0800
+++ gettext-1.05/Makefile.PL	2008-12-12 11:20:25.000000000 -0800
@@ -35,6 +35,8 @@
     NAME => "Locale::gettext",
     LIBS => ($libs eq '') ? [] : [$libs],
     VERSION_FROM => 'gettext.pm', 
+    CC => $cc,
+    LD => $cc,
 );
 
 sub conftest {
