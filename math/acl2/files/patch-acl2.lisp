--- acl2.lisp.sav	Wed Nov 13 19:52:52 2002
+++ acl2.lisp	Fri Apr 25 16:05:10 2003
@@ -121,7 +121,7 @@
 
 ; For example, for Allegro and lispworks (respectively) we have the following.
 
-#+(or DRAFT-ANSI-CL-2 lispworks clisp)
+#+(or DRAFT-ANSI-CL-2 lispworks clisp openmcl)
 (push :CLTL2 *features*)
 
 ; We use IN-PACKAGE in a way that is consistent with both CLTL1 and
@@ -557,7 +557,7 @@
   #+allegro "fasl"
   #+lispworks "ufsl" ; was "wfasl" for 3.2.0
   #+(and mcl (not ppc-target)) "fasl"
-  #+(and mcl ppc-target) "pfsl"
+  #+(and mcl ppc-target) "dfsl"
   #+symbolics "bin"
   #+(and cmu sparc) "sparcf"
   #+(and cmu alpha) "axpf"
