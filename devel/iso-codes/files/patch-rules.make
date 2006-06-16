--- rules.make~	2006-06-16 12:35:08.000000000 -0400
+++ rules.make	2006-06-16 12:35:50.000000000 -0400
@@ -12,7 +12,8 @@
 		cat=`basename $$cat`; \
 		lang=`echo $$cat | sed 's/\.mo$$//'`; \
 		dir=$(DESTDIR)$(localedir)/$$lang/LC_MESSAGES; \
-		$(INSTALL_DATA) -D $$cat $$dir/$(DOMAIN).mo; \
+		$(mkinstalldirs) $$dir; \
+		$(INSTALL_DATA) $$cat $$dir/$(DOMAIN).mo; \
 	done
 
 uninstall-hook:
