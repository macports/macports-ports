--- Source/setup.py.org	2007-03-31 15:05:46.000000000 +0200
+++ Source/setup.py	2007-03-31 15:05:21.000000000 +0200
@@ -198,7 +198,7 @@
 
                 # 10.4 needs the libintl.a but 10.3 does not
                 template_values['extra_libs'] = '%(svn_lib_dir)s/libintl.a' % template_values
-                template_values['frameworks'] = '-framework System %s -framework CoreFoundation -framework Kerberos' % framework_lib
+                template_values['frameworks'] = '-framework System %s -framework CoreFoundation -framework Kerberos -framework Security' % framework_lib
             else:
                 if self.verbose:
                     print 'Info: Using Mac OS X 10.3 makefile template'
@@ -209,9 +209,6 @@
             if self.is_mac_os_x_fink:
                 makefile.write( self.makefile_template_macosx_fink % template_values )
 
-            elif self.is_mac_os_x_darwin_ports:
-                makefile.write( self.makefile_template_macosx_darwin_ports % template_values )
-
             else:
                 makefile.write( self.makefile_template_macosx % template_values )
         elif sys.platform.startswith('aix'):
