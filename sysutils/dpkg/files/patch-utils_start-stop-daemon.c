--- utils/start-stop-daemon.c	Sun May 13 15:01:28 2001
+++ utils/start-stop-daemon.c	Sat Oct  5 22:22:21 2002
@@ -30,6 +30,8 @@
 #  define OSsunos
 #elif defined(OPENBSD)
 #  define OSOpenBSD
+#elif defined(__APPLE__)
+#  define OSDarwin
 #else
 #  error Unknown architecture - cannot build start-stop-daemon
 #endif
@@ -41,7 +43,7 @@
 #  include <ps.h>
 #endif
 
-#if defined(OSOpenBSD)
+#if defined(OSOpenBSD) || defined(OSDarwin)
 #include <sys/param.h>
 #include <sys/user.h>
 #include <sys/proc.h>
@@ -653,11 +655,12 @@
 {
 #if defined(OSLinux)
 	if (execname && !pid_is_exec(pid, &exec_stat))
+		return;
 #elif defined(OSHURD)
     /* I will try this to see if it works */
 	if (execname && !pid_is_cmd(pid, execname))
-#endif
 		return;
+#endif
 	if (userspec && !pid_is_user(pid, user_id))
 		return;
 	if (cmdname && !pid_is_cmd(pid, cmdname))
@@ -787,7 +790,7 @@
 }
  
 int
-pid_is_user(pid_t pid, int uid)
+pid_is_user(pid_t pid, uid_t uid)
 {
 	kvm_t *kd;
 	int nentries;   /* Value not used */
@@ -828,7 +831,6 @@
 	return (strcmp(name, pidexec) == 0) ? 1 : 0;
 }
 
-
 static void
 do_procinit(void)
 {
@@ -836,6 +838,80 @@
 }
 
 #endif /* OSOpenBSD */
+
+#if defined(OSDarwin)
+int
+pid_is_user(pid_t pid, uid_t uid)
+{
+	int mib[4];
+	size_t size;
+	struct kinfo_proc ki;
+
+	size = sizeof(ki);
+	mib[0] = CTL_KERN;
+	mib[1] = KERN_PROC;
+	mib[2] = KERN_PROC_PID;
+	mib[3] = pid;
+	if (sysctl(mib, 4, &ki, &size, NULL, 0) < 0)
+		errx(1, "%s", "Failure calling sysctl");
+	return (uid == ki.kp_eproc.e_pcred.p_ruid);
+}
+
+static int
+pid_is_cmd(pid_t pid, const char *name)
+{
+	int mib[4];
+	size_t size;
+	struct kinfo_proc ki;
+
+	size = sizeof(ki);
+	mib[0] = CTL_KERN;
+	mib[1] = KERN_PROC;
+	mib[2] = KERN_PROC_PID;
+	mib[3] = pid;
+	if (sysctl(mib, 4, &ki, &size, NULL, 0) < 0)
+		errx(1, "%s", "Failure calling sysctl");
+	return (!strncmp(name, ki.kp_proc.p_comm, MAXCOMLEN));
+}
+
+static void
+do_procinit(void)
+{
+	int mib[3];
+	size_t size;
+	int nprocs, ret, i;
+	struct kinfo_proc *procs = NULL, *newprocs;
+	
+	mib[0] = CTL_KERN;
+	mib[1] = KERN_PROC;
+	mib[2] = KERN_PROC_ALL;
+	ret = sysctl(mib, 3, NULL, &size, NULL, 0);
+	/* Allocate enough memory for entire process table */
+	do {
+		size += size / 10;
+		newprocs = realloc(procs, size);
+		if (newprocs == NULL) {
+			if (procs)
+				free(procs);
+			errx(1, "%s", "Could not reallocate memory");
+		}
+		procs = newprocs;
+		ret = sysctl(mib, 3, procs, &size, NULL, 0);
+	} while (ret >= 0 && errno == ENOMEM);
+
+	if (ret < 0)
+		errx(1, "%s", "Failure calling sysctl");
+
+	/* Verify size of proc structure */
+	if (size % sizeof(struct kinfo_proc) != 0)
+		errx(1, "%s", "proc size mismatch, userland out of sync with kernel");
+	nprocs = size / sizeof(struct kinfo_proc);
+	for (i = 0; i < nprocs; i++) {
+		check(procs[i].kp_proc.p_pid);
+	}
+}
+#endif
+
 
 
 static void
