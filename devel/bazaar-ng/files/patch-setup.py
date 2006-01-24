--- setup.py	2006-01-23 10:33:09.000000000 +0100
+++ setup.py	2006-01-24 08:15:04.000000000 +0100
@@ -102,5 +102,5 @@
                 ],
       scripts=['bzr'],
       cmdclass={'install_scripts': my_install_scripts, 'build': bzr_build},
-      data_files=[('man/man1', ['bzr.1'])],
+      data_files=[('share/man/man1', ['bzr.1'])],
      )
