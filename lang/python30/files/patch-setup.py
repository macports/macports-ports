--- setup.py	2007-08-29 00:24:48.000000000 +0200
+++ setup.py	2007-09-01 00:44:50.000000000 +0200
@@ -15,7 +15,7 @@
 from distutils.command.install_lib import install_lib
 
 # This global variable is used to hold the list of modules to be disabled.
-disabled_module_list = []
+disabled_module_list = ["zlib","_hashlib","_ssl","_bsddb","_sqlite3","_tkinter","bz2","gdbm","readline","_curses","_curses_panel"]
 
 def add_dir_to_list(dirlist, dir):
     """Add the directory 'dir' to the list 'dirlist' (at the front) if
