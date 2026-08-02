--- uxspec.c-orig	Sat Apr 17 15:39:42 2004
+++ uxspec.c	Tue Aug  3 12:48:30 2004
@@ -343,14 +343,14 @@
       group received from getpwnam() */
    if(i<l-1&&(gr=getgrnam(tmp+i+1))!=NULL)
     gid=gr->gr_gid;
-   rc=lchown(name, pw->pw_uid, gid);
+   rc=chown(name, pw->pw_uid, gid);
    return(rc);
   }
   else
   {
    if(l!=8)
     return(-1);
-   return(lchown(name, mget_dword(storage+1), mget_dword(storage+5)));
+   return(chown(name, mget_dword(storage+1), mget_dword(storage+5)));
   }
  #else
   return(-1);
