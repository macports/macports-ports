--- gen/mk-static-filter.pl.orig	2007-12-03 07:43:09.000000000 +0100
+++ gen/mk-static-filter.pl	2008-04-18 22:34:26.000000000 +0200
@@ -159,7 +159,7 @@
   printf STATICFILTERS "\n  const KeyInfo * ".${$filter}{"NAME"}."_options_begin = ".
                                               ${$filter}{"NAME"}."_options;\n";
   # If structure is empty, set options_end to same as options_begin.
-  if (%{$filter}) {
+  if ($firstopt) {
     printf STATICFILTERS "\n  const KeyInfo * ".${$filter}{"NAME"}."_options_end = ".
                                                 ${$filter}{"NAME"}."_options;\n";
   } else {
