--- unix/unix.mak.orig	Thu Mar 25 17:14:30 2004
+++ unix/unix.mak	Thu Mar 25 17:14:41 2004
@@ -83,7 +83,7 @@
 	chmod $(MODE) $(TF)
 
 SYMLINK $(SYMLINK): $(TF)
-	test -z "$(SYMLINK)" || { rm -f $(SYMLINK) && ln -s $(TF) $(SYMLINK); }
+	test -z "$(SYMLINK)" || { rm -f $(SYMLINK) && ln -s tf-$(TFVER) $(SYMLINK); }
 
 LIBRARY $(LIBDIR): ../tf-lib/tf-help ../tf-lib/tf-help.idx
 	@echo '## Creating library directory...'
