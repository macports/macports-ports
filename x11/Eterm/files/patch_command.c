--- src/command.c.org	Wed Jun  9 15:14:36 2004
+++ src/command.c	Wed Jun  9 15:16:11 2004
@@ -199,23 +199,11 @@
           /* Revoke suid/sgid privs and return to normal uid/gid -- mej */
           D_UTMP(("[%ld]: Before privileges(REVERT): [ %ld, %ld ]  [ %ld, %ld ]\n", getpid(), getuid(), getgid(), geteuid(), getegid()));
 
-#ifdef HAVE_SETRESGID
-          setresgid(my_rgid, my_rgid, my_egid);
-#elif defined(HAVE_SAVED_UIDS)
-          setregid(my_rgid, my_rgid);
-#else
           setregid(my_egid, -1);
           setregid(-1, my_rgid);
-#endif
 
-#ifdef HAVE_SETRESUID
-          setresuid(my_ruid, my_ruid, my_euid);
-#elif defined(HAVE_SAVED_UIDS)
-          setreuid(my_ruid, my_ruid);
-#else
           setreuid(my_euid, -1);
           setreuid(-1, my_ruid);
-#endif
 
           D_UTMP(("[%ld]: After privileges(REVERT): [ %ld, %ld ]  [ %ld, %ld ]\n", getpid(), getuid(), getgid(), geteuid(), getegid()));
           break;
@@ -226,23 +214,11 @@
       case RESTORE:
           D_UTMP(("[%ld]: Before privileges(INVOKE): [ %ld, %ld ]  [ %ld, %ld ]\n", getpid(), getuid(), getgid(), geteuid(), getegid()));
 
-#ifdef HAVE_SETRESUID
-          setresuid(my_ruid, my_euid, my_euid);
-#elif defined(HAVE_SAVED_UIDS)
-          setreuid(my_ruid, my_euid);
-#else
           setreuid(-1, my_euid);
           setreuid(my_ruid, -1);
-#endif
 
-#ifdef HAVE_SETRESGID
-          setresgid(my_rgid, my_egid, my_egid);
-#elif defined(HAVE_SAVED_UIDS)
-          setregid(my_rgid, my_egid);
-#else
           setregid(-1, my_egid);
           setregid(my_rgid, -1);
-#endif
 
           D_UTMP(("[%ld]: After privileges(INVOKE): [ %ld, %ld ]  [ %ld, %ld ]\n", getpid(), getuid(), getgid(), geteuid(), getegid()));
           break;
