--- main/archives.c.orig	Thu Nov 11 20:10:03 2004
+++ main/archives.c	Fri Dec 17 17:34:55 2004
@@ -312,6 +312,7 @@
 int tarobject(struct TarInfo *ti) {
   static struct varbuf conffderefn, hardlinkfn, symlinkfn;
   const char *usename;
+  char *s = NULL;
     
   struct tarcontext *tc= (struct tarcontext*)ti->UserData;
   int statr, fd, i, existingdirectory;
@@ -357,7 +358,15 @@
                 divpkg ? ")" : "");
   }
 
-  usename= namenodetouse(nifd->namenode,tc->pkg)->name + 1; /* Skip the leading `/' */
+  usename= namenodetouse(nifd->namenode,tc->pkg)->name; /* Skip the leading `/' */
+  if (*usename == '.' && *usename + 1 == '/') {
+	usename += 1; /* Skip the leading `.' */
+  } else if (*usename != '/') {
+	s = malloc(strlen(usename) + 2); /* 1 for NULL, one for `/' we're going to add */
+	strcpy(s + 1, usename);
+	*s = '/';
+	usename = s;
+  }
 
   if (nifd->namenode->flags & fnnf_new_conff) {
     /* If it's a conffile we have to extract it next to the installed
@@ -369,6 +378,10 @@
   }
   
   setupfnamevbs(usename);
+
+  if (s != NULL) {
+	free(s);
+  }
 
   statr= lstat(fnamevb.buf,&stab);
   if (statr) {
