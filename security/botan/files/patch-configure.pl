--- configure.pl	Mon Mar 14 01:31:05 2005
+++ ../../configure.pl	Wed Apr 13 18:52:26 2005
@@ -680,7 +680,7 @@
       'beos'       => 'ld -shared -h $(SONAME)',
       'default'    => '$(CXX) -shared -fPIC -Wl,-soname,$(SONAME)',
       'hpux'       => '$(CXX) -shared -fPIC -Wl,+h,$(SONAME)',
-      'macosx'     => '$(CXX) -dynamiclib -fPIC -install_name $(SONAME)',
+      'macosx'     => '$(CXX) -dynamiclib -fPIC -install_name $(LIBDIR)/$(SONAME)',
       'solaris'    => '$(CXX) -shared -fPIC -Wl,-h,$(SONAME)',
       },
    'hpcc'       => {
@@ -2083,7 +2083,7 @@
 BINDIR        = \$(INSTALLROOT)/bin
 LIBDIR        = \$(INSTALLROOT)/$lib_dir
 HEADERDIR     = \$(INSTALLROOT)/$header_dir/botan
-DOCDIR        = \$(INSTALLROOT)/$doc_dir/Botan-\$(VERSION)
+DOCDIR        = \$(INSTALLROOT)/share/doc/botan
 
 OWNER         = $install_user
 GROUP         = $install_group
