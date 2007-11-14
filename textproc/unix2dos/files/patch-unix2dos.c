--- work/unix2dos-2.2.src/unix2dos.c	1995-03-30 18:03:23.000000000 +0200
+++ unix2dos.c	2007-11-14 23:21:10.000000000 +0100
@@ -131,9 +131,9 @@
  * RetVal: NULL if failure
  *         file stream otherwise
  */
-FILE* OpenOutFile(char *ipFN)
+FILE* OpenOutFile(int fd)
 {
-  return (fopen(ipFN, W_CNTRL));
+  return (fdopen(fd, W_CNTRL));
 }
 
 
@@ -207,14 +207,17 @@
   char TempPath[16];
   struct stat StatBuf;
   struct utimbuf UTimeBuf;
+  int fd;
 
   /* retrieve ipInFN file date stamp */
   if ((ipFlag->KeepDate) && stat(ipInFN, &StatBuf))
     RetVal = -1;
 
-  strcpy (TempPath, "./u2dtmp");
-  strcat (TempPath, "XXXXXX");
-  mktemp (TempPath);
+  strcpy (TempPath, "./u2dtmpXXXXXX");
+  if((fd=mkstemp (TempPath)) < 0) {
+	  perror("Can't open output temp file");
+	  RetVal = -1;
+  }
 
 #ifdef DEBUG
   fprintf(stderr, "unix2dos: using %s as temp file\n", TempPath);
@@ -225,7 +228,7 @@
     RetVal = -1;
 
   /* can open out file? */
-  if ((!RetVal) && (InF) && ((TempF=OpenOutFile(TempPath)) == NULL))
+  if ((!RetVal) && (InF) && ((TempF=OpenOutFile(fd)) == NULL))
   {
     fclose (InF);
     RetVal = -1;
@@ -243,6 +246,9 @@
   if ((TempF) && (fclose(TempF) == EOF))
     RetVal = -1;
 
+  if(fd>=0)
+	  close(fd);
+
   if ((!RetVal) && (ipFlag->KeepDate))
   {
     UTimeBuf.actime = StatBuf.st_atime;
@@ -286,14 +292,17 @@
   char TempPath[16];
   struct stat StatBuf;
   struct utimbuf UTimeBuf;
+  int fd;
 
   /* retrieve ipInFN file date stamp */
   if ((ipFlag->KeepDate) && stat(ipInFN, &StatBuf))
     RetVal = -1;
 
-  strcpy (TempPath, "./u2dtmp");
-  strcat (TempPath, "XXXXXX");
-  mktemp (TempPath);
+  strcpy (TempPath, "./u2dtmpXXXXXX");
+  if((fd=mkstemp (TempPath)) < 0) {
+      perror("Can't open output temp file");
+      RetVal = -1;
+  }
 
 #ifdef DEBUG
   fprintf(stderr, "unix2dos: using %s as temp file\n", TempPath);
@@ -304,7 +313,7 @@
     RetVal = -1;
 
   /* can open out file? */
-  if ((!RetVal) && (InF) && ((TempF=OpenOutFile(TempPath)) == NULL))
+  if ((!RetVal) && (InF) && ((TempF=OpenOutFile(fd)) == NULL))
   {
     fclose (InF);
     RetVal = -1;
@@ -322,6 +331,9 @@
   if ((TempF) && (fclose(TempF) == EOF))
     RetVal = -1;
 
+  if(fd>=0)
+	  close(fd);
+
   if ((!RetVal) && (ipFlag->KeepDate))
   {
     UTimeBuf.actime = StatBuf.st_atime;
