--- setup.py	2006-05-22 13:11:12.000000000 -0700
+++ setup.py	2006-05-16 21:01:47.000000000 -0700
@@ -115,6 +115,6 @@
                 ],
       scripts=['bzr'],
       cmdclass={'install_scripts': my_install_scripts, 'build': bzr_build},
-      data_files=[('man/man1', ['bzr.1'])],
+      data_files=[('share/man/man1', ['bzr.1'])],
     #   todo: install the txt files from bzrlib.doc.api.
      )
