--- work/Botan-1.4.10/configure.pl	2005-12-18 23:19:29.000000000 +0100
+++ configure.pl	2005-12-19 17:07:25.000000000 +0100
@@ -372,7 +372,7 @@
       'root'       => 'c:\Botan',
       },
    'darwin'     => {
-      'docs'       => 'doc',
+      'docs'       => 'share/doc',
       'group'      => 'wheel',
       },
    'defaults'   => {
@@ -701,7 +701,7 @@
    'gcc'        => {
       'aix'        => '$(CXX) -shared -fPIC',
       'beos'       => 'ld -shared -h $(SONAME)',
-      'darwin'     => '$(CXX) -dynamiclib -fPIC -install_name $(SONAME)',
+      'darwin'     => '$(CXX) -dynamiclib -fPIC -install_name $(LIBDIR)/$(SONAME)',
       'default'    => '$(CXX) -shared -fPIC -Wl,-soname,$(SONAME)',
       'hpux'       => '$(CXX) -shared -fPIC -Wl,+h,$(SONAME)',
       'solaris'    => '$(CXX) -shared -fPIC -Wl,-h,$(SONAME)',
@@ -2125,7 +2125,7 @@
 BINDIR        = \$(INSTALLROOT)/bin
 LIBDIR        = \$(INSTALLROOT)/$lib_dir
 HEADERDIR     = \$(INSTALLROOT)/$header_dir/botan
-DOCDIR        = \$(INSTALLROOT)/$doc_dir/Botan-\$(VERSION)
+DOCDIR        = \$(INSTALLROOT)/$doc_dir/botan
 
 OWNER         = $install_user
 GROUP         = $install_group
