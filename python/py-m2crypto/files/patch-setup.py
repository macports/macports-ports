--- setup.py	2017-10-15 01:36:00.000000000 -0500
+++ setup.py	2017-10-15 01:36:50.000000000 -0500
@@ -229,8 +229,8 @@
                                 sources=lib_sources,
                                 extra_compile_args=list(x_comp_args),
                                 # Uncomment to build Universal Mac binaries
-                                # extra_link_args =
-                                #     ['-Wl,-search_paths_first'],
+                                extra_link_args =
+                                    ['-Wl,-search_paths_first'],
                                 )
