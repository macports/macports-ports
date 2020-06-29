--- setup.py.orig	2020-06-29 17:37:32.000000000 -0400
+++ setup.py	2020-06-29 17:38:06.000000000 -0400
@@ -68,9 +68,6 @@
                 # Issue #628
                 '-Wno-nullability-extension',
                 '-Wno-newline-eof',
-
-                # required w/Xcode 5.1+ and above because of '-mno-fused-madd'
-                '-Wno-error=unused-command-line-argument'
             ]
         ),
     ]
