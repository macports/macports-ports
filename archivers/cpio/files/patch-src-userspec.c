--- src/userspec.c	2004-09-06 14:23:06.000000000 +0200
+++ src/userspec.c	2005-11-07 21:21:50.000000000 +0100
@@ -72,7 +72,7 @@
    otherwise return 0. */
 
 static int
-isnumber (const char *str)
+cpio_isnumber (const char *str)
 {
   for (; *str; str++)
     if (!isdigit (*str))
@@ -136,7 +136,7 @@
       if (pwd == NULL)
 	{
 
-	  if (!isnumber (u))
+	  if (!cpio_isnumber (u))
 	    error_msg = _("invalid user");
 	  else
 	    {
@@ -182,7 +182,7 @@
       grp = getgrnam (g);
       if (grp == NULL)
 	{
-	  if (!isnumber (g))
+	  if (!cpio_isnumber (g))
 	    error_msg = _("invalid group");
 	  else
 	    *gid = atoi (g);
