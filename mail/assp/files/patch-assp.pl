--- assp.pl.orig	Thu Jan 13 23:25:31 2005
+++ assp.pl	Thu Jan 13 23:26:49 2005
@@ -730,18 +730,19 @@
   if($(+0==$gid) {
    mlog('',"Switched real gid to $gid ($gname)");
   } else {
-   mlog('',"Failed to switch real gid to $gid ($gname) -- real uid=$(");
+   mlog('',"Failed to switch real gid to $gid ($gname) -- real gid=$(");
   }
  }
  if($uid) {
   # do it both ways so linux and bsd are happy
-  $<=$uid; $>=$uid; $<=$uid; $>=$uid;
+  $>=$uid;
   if($>==$uid) {
   mlog('',"Switched effective uid to $uid ($uname)");
   } else {
    mlog('',"Failed to switch effective uid to $uid ($uname) -- real uid=$< -- quitting");
    die "Failed to switch effective uid to $uid ($uname) -- real uid=$< -- quitting";
   }
+  $<=$uid;
   if($<==$uid) {
    mlog('',"Switched real uid to $uid ($uname)");
   } else {
