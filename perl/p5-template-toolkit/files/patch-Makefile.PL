--- Makefile.PL.orig	Thu Oct  9 01:48:41 2003
+++ Makefile.PL	Thu Apr  8 20:10:28 2004
@@ -200,20 +200,20 @@
     return '' unless $main::TT_PREFIX;
     my $amble =<<'EOF';
 tt2_install ::
-	@$(PERL) bin/tt2inst -v "$(TT_PREFIX)"
+	@$(PERL) bin/tt2inst -v "$(DESTDIR)/$(TT_PREFIX)"
 
 tt2_splash ::
-	@$(PERL) -I$(INST_LIB) -I$(INST_ARCHLIB) bin/gifsplash -v -i "$(TT_PREFIX)"
+	@$(PERL) -I$(INST_LIB) -I$(INST_ARCHLIB) bin/gifsplash -v -i "$(DESTDIR)/$(TT_PREFIX)"
 
 EOF
     $amble .=<<EOF if $main::TT_BUILD_DOCS;
 tt2_html_docs ::
-	\@\$(PERL) -I\$(INST_LIB) -I\$(INST_ARCHLIB) bin/ttree -v -f "\$(TT_PREFIX)/$TT_DOCS_CFG"
+	\@\$(PERL) -I\$(INST_LIB) -I\$(INST_ARCHLIB) bin/ttree -v -f "\$(DESTDIR)/\$(TT_PREFIX)/$TT_DOCS_CFG"
 
 EOF
     $amble .=<<EOF if $main::TT_EXAMPLES;
 tt2_examples ::
-	\@\$(PERL) -I\$(INST_LIB) -I\$(INST_ARCHLIB) bin/ttree -v -f "\$(TT_PREFIX)/$TT_EXAMPLE_CFG"
+	\@\$(PERL) -I\$(INST_LIB) -I\$(INST_ARCHLIB) bin/ttree -v -f "\$(DESTDIR)/\$(TT_PREFIX)/$TT_EXAMPLE_CFG"
 
 EOF
     return $amble;
