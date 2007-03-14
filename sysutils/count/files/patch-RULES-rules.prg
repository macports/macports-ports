--- RULES/rules.prg	2000-03-19 17:16:43.000000000 +0100
+++ RUKES/rules.prg	2007-03-14 20:42:38.000000000 +0100
@@ -75,7 +75,7 @@
 
 LD=		@echo "	==> LINKING   \"$@\""; ld
 LOCALIZE=	@echo "	==> LOCALIZING \"$@\""; $(RM_F) $@; cp
-INSTALL=	@echo "	==> INSTALLING \"$@\""; sh $(SRCROOT)/conf/install-sh -c -m $(INSMODEINS) -o $(INSUSR) -g $(INSGRP)
+INSTALL=	@echo "	==> INSTALLING \"$@\""; sh $(SRCROOT)/conf/install-sh -c -m $(INSMODEINS)
 CHMOD=		@echo "	==> SEETING PERMISSIONS ON \"$@\""; chmod
 CHOWN=		@echo "	==> SETTING OWNER ON \"$@\""; chown
 CHGRP=		@echo "	==> SETTING GROUP ON \"$@\""; chgrp
