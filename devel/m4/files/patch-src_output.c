--- src/output.c        5 Jul 2007 03:53:08 -0000       1.1.1.1.2.23
+++ src/output.c        22 Jul 2007 04:23:17 -0000
@@ -252,6 +252,11 @@ m4_tmpopen (int divnum)
   else if (set_cloexec_flag (fileno (file), true) != 0)
     M4ERROR ((warning_status, errno,
	      "Warning: cannot protect diversion across forks"));
+  /* POSIX states that it is undefined whether an append stream starts
+     at offset 0 or at the end.  We want the beginning.  */
+  else if (fseeko (file, 0, SEEK_SET) != 0)
+    M4ERROR ((EXIT_FAILURE, errno,
+	      "cannot seek to beginning of diversion"));
   return file;
 }

