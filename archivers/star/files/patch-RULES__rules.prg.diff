--- RULES/rules.prg.orig	Tue Jan  4 16:57:05 2005
+++ RULES/rules.prg	Tue Jan  4 16:57:41 2005
@@ -75,7 +75,7 @@
 
 LD=		@echo "	==> LINKING   \"$@\""; ld
 LOCALIZE=	@echo "	==> LOCALIZING \"$@\""; $(RM_F) $@; cp
-INSTALL=	@echo "	==> INSTALLING \"$@\""; sh $(SRCROOT)/conf/install-sh -c -m $(INSMODEINS) -o $(INSUSR) -g $(INSGRP)
+INSTALL=	@echo "	==> INSTALLING \"$@\""; sh $(SRCROOT)/conf/install-sh -c -m $(INSMODEINS)
 CHMOD=		@echo "	==> SEETING PERMISSIONS ON \"$@\""; chmod
 CHOWN=		@echo "	==> SETTING OWNER ON \"$@\""; chown
 CHGRP=		@echo "	==> SETTING GROUP ON \"$@\""; chgrp
