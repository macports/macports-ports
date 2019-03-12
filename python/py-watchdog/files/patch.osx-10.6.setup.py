--- setup.orig.py	2015-02-11 10:54:50.000000000 +0100
+++ setup.py	2017-12-21 19:09:58.000000000 +0100
@@ -56,9 +56,6 @@
                 '-Wall',
                 '-Wextra',
                 '-fPIC',
-
-                # required w/Xcode 5.1+ and above because of '-mno-fused-madd'
-                '-Wno-error=unused-command-line-argument-hard-error-in-future'
             ]
         ),
     ]
