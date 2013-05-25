--- project.mak	2012-12-10 10:47:31.000000000 +0100
+++ project.mak	2013-05-25 18:23:28.000000000 +0200
@@ -109,7 +109,7 @@
 
 ifeq ($(INSTMETH),findlib)
 install:
-	$(OCAMLFIND) install -destdir "$(INSTALLDIR)" zarith META $(TOINSTALL) dllzarith.dll
+	$(OCAMLFIND) install -destdir "$(INSTALLDIR)" zarith META $(TOINSTALL) dllzarith.$(DLLSUFFIX)
 
 uninstall:
 	$(OCAMLFIND) remove -destdir "$(INSTALLDIR)" zarith
