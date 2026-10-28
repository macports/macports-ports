--- apps/irssi/src/perl/perl-common.h.org	2006-02-15 19:20:03.000000000 +0100
+++ apps/irssi/src/perl/perl-common.h	2006-02-15 19:21:56.000000000 +0100
@@ -26,12 +26,6 @@
    Increases the reference counter for the return value. */
 SV *perl_func_sv_inc(SV *func, const char *package);
 
-/* For compatibility with perl 5.004 and older */
-#ifndef HAVE_PL_PERL
-#  define PL_sv_undef sv_undef
-extern STRLEN PL_na;
-#endif
-
 #ifndef pTHX_
 #  define pTHX_
 #endif
