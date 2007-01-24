--- src/speedy_perl.h.org	2003-10-06 21:03:48.000000000 -0700
+++ src/speedy_perl.h	2007-01-23 11:07:02.000000000 -0800
@@ -21,4 +21,4 @@
 void speedy_perl_run(slotnum_t _gslotnum, slotnum_t _bslotnum);
 int speedy_perl_fork(void);
 
-PerlInterpreter  *my_perl;
+extern PerlInterpreter  *my_perl;
