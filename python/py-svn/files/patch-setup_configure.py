--- Source/setup_configure.py.orig	2011-01-01 00:19:01.000000000 +1100
+++ Source/setup_configure.py	2011-04-13 16:22:11.000000000 +1000
@@ -337,7 +337,11 @@
             # python framework will be used and not the one matching this python
             var_prefix = distutils.sysconfig.get_config_var('prefix')
             var_ldlibrary = distutils.sysconfig.get_config_var('LDLIBRARY')
-            framework_lib = os.path.join( var_prefix, os.path.basename( var_ldlibrary ) )
+            if distutils.sysconfig.get_config_var('PYTHONFRAMEWORKDIR') != 'no-framework':
+                framework_lib = os.path.join( var_prefix, os.path.basename( var_ldlibrary ) )
+            else:
+                var_libpl = distutils.sysconfig.get_config_var('LIBPL')
+                framework_lib = os.path.join( var_libpl, os.path.basename( var_ldlibrary ) ) + ' -undefined dynamic_lookup'
 
             if self.is_atleast_mac_os_x_version( (10,5) ) >= 0:
                 if self.verbose:
@@ -364,9 +368,6 @@
             if self.is_mac_os_x_fink:
                 makefile.write( self.makefile_template_macosx_fink % template_values )
 
-            elif self.is_mac_os_x_darwin_ports:
-                makefile.write( self.makefile_template_macosx_darwin_ports % template_values )
-
             else:
                 if sys.version_info[0] >= 3:
                     makefile.write( self.makefile_template_macosx_one_arch_py3 % template_values )
