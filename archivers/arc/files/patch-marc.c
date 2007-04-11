--- marc.c.orig	2007-04-11 11:52:45.000000000 -0700
+++ marc.c	2007-04-11 11:53:14.000000000 -0700
@@ -53,7 +53,6 @@ main(nargs,arg)			       /* system entry
 int nargs;			       /* number of arguments */
 char *arg[];			       /* pointers to arguments */
 {
-    char *makefnam();
     char *envfind();
 #if	!_MTS
     char *arctemp2, *mktemp();		/* temp file stuff */
@@ -319,7 +318,6 @@ int n;				       /* number of entry to e
     char buf[100];		       /* input buffer */
     int x;			       /* index */
     char *p = lst[n]+1;		       /* filename pointer */
-    char *makefnam();
 
     if(*p)			       /* use name if one was given */
     {	 makefnam(p,".CMD",buf);
