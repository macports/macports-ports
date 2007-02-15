--- Instance/Documentation/latex.make.orig	2007-02-14 23:27:30.000000000 -0500
+++ Instance/Documentation/latex.make	2007-02-14 23:28:01.000000000 -0500
@@ -65,7 +65,7 @@
 # Targets built only if we can find `latex2html'
 #
 # NB: you may set LATEX2HTML on the command line if the following doesn't work
-LATEX2HTML = $(shell which latex2html | awk '{print $$1}' |  sed -e 's/which://')
+LATEX2HTML = $(shell which latex2html | awk '{print $$1}' |  sed -e 's/no//')
 
 ifneq ($(LATEX2HTML),)
   HAS_LATEX2HTML = yes
