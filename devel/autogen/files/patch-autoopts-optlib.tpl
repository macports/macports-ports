--- autoopts/optlib.tpl	2007-09-08 18:23:26.000000000 +0200
+++ autoopts/optlib.tpl	2007-10-29 02:03:59.000000000 +0100
@@ -465,7 +465,7 @@
 DEFINE   emit-nondoc-option     =][=
   (if (exist? "translators")
       (string-append "\n" (shellf
-"(fmt --width 60|columns -I16 -c1 --first='/* TRANSLATORS:')<<\\_EOF_
+"(gfmt --width 60|columns -I16 -c1 --first='/* TRANSLATORS:')<<\\_EOF_
 %s
 _EOF_" (get "translators")  ) " */" )  ) =][=
 
