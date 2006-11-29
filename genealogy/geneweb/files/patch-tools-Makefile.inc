--- tools/Makefile.inc.orig	2006-04-15 20:44:36.000000000 -0700
+++ tools/Makefile.inc	2006-04-15 20:44:48.000000000 -0700
@@ -2,11 +2,11 @@
 
 TOP=..
 CAMLP4_COMM=TOP=$(TOP) $(TOP)/tools/camlp4_comm.sh pa_ifdef.cmo
-CAMLP4F=-DUNIX
+CAMLP4F=-DUNIX -loc loc
 CAMLP4D=`camlp4 -where`
 LIBUNIX=-cclib -lunix
-OCAMLC=ocamlc.opt -warn-error A
-OCAMLOPT=ocamlopt.opt -warn-error A
+OCAMLC=ocamlc.opt
+OCAMLOPT=ocamlopt.opt
 OCAMLI=
 OCAMLD=
 STRIP=strip
