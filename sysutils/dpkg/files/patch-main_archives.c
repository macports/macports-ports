--- src/archives.c.orig	Thu Nov 11 20:10:03 2004
+++ src/archives.c	Fri Dec 17 17:34:55 2004
@@ -373,6 +373,7 @@
   static struct varbuf conffderefn, hardlinkfn, symlinkfn;
   static int fd;
   const char *usename;
+  char *s = NULL;
 
   struct conffile *conff;
   struct tarcontext *tc= (struct tarcontext*)ti->UserData;
@@ -423,7 +424,15 @@
     }
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
@@ -435,6 +444,10 @@
   }
   
   setupfnamevbs(usename);
+
+  if (s != NULL) {
+	free(s);
+  }
 
   statr= lstat(fnamevb.buf,&stab);
   if (statr) {
