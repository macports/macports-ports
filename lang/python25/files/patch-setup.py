--- setup.py	2006-08-10 01:42:18.000000000 +0200
+++ setup.py	2007-02-17 16:57:24.000000000 +0100
@@ -15,7 +15,7 @@
 from distutils.command.install_lib import install_lib
 
 # This global variable is used to hold the list of modules to be disabled.
-disabled_module_list = []
+disabled_module_list = ["zlib","_hashlib","_ssl","_bsddb","_sqlite3","_tkinter","bz2","gdbm","readline","_curses","_curses_panel"]
 
 def add_dir_to_list(dirlist, dir):
     """Add the directory 'dir' to the list 'dirlist' (at the front) if
