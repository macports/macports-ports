--- work/Botan-1.4.7/configure.pl	2005-09-26 03:57:10.000000000 +0200
+++ configure.pl	2005-09-26 12:34:33.000000000 +0200
@@ -374,7 +374,7 @@
       'root'       => 'c:\Botan',
       },
    'darwin'     => {
-      'docs'       => 'doc',
+      'docs'       => 'share/doc',
       'group'      => 'wheel',
       },
    'defaults'   => {
@@ -703,7 +703,7 @@
    'gcc'        => {
       'aix'        => '$(CXX) -shared -fPIC',
       'beos'       => 'ld -shared -h $(SONAME)',
-      'darwin'     => '$(CXX) -dynamiclib -fPIC -install_name $(SONAME)',
+      'darwin'     => '$(CXX) -dynamiclib -fPIC -install_name $(LIBDIR)/$(SONAME)',
       'default'    => '$(CXX) -shared -fPIC -Wl,-soname,$(SONAME)',
       'hpux'       => '$(CXX) -shared -fPIC -Wl,+h,$(SONAME)',
       'solaris'    => '$(CXX) -shared -fPIC -Wl,-h,$(SONAME)',
@@ -2111,7 +2111,7 @@
 BINDIR        = \$(INSTALLROOT)/bin
 LIBDIR        = \$(INSTALLROOT)/$lib_dir
 HEADERDIR     = \$(INSTALLROOT)/$header_dir/botan
-DOCDIR        = \$(INSTALLROOT)/$doc_dir/Botan-\$(VERSION)
+DOCDIR        = \$(INSTALLROOT)/$doc_dir/botan
 
 OWNER         = $install_user
 GROUP         = $install_group
