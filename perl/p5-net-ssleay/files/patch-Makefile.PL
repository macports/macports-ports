--- Makefile.PL	2005-12-09 02:41:42.000000000 -0800
+++ Makefile.PL	2006-12-04 20:38:57.000000000 -0800
@@ -128,7 +129,7 @@
     ### Check that perl and openssl were compiled using the same compiler
     ### and options.
 
-    ($cc_et_alia) = grep /cc\s+-/i, `strings $exe_path`;
+    ($cc_et_alia) = grep /cc(|-\d+(|\.)\d*)\s+-/i, `strings $exe_path`;
     if ($cc_et_alia) {
 	($cc, %flags) = split /\s+/, $cc_et_alia;
 	if ($cc eq $Config{cc}) {
