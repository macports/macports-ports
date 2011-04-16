--- utils/start-stop-daemon.c.orig	Thu Nov 11 12:10:04 2004
+++ utils/start-stop-daemon.c	Mon Dec 13 16:02:18 2004
@@ -38,6 +38,8 @@
 #  define OSFreeBSD
 #elif defined(__NetBSD__)
 #  define OSNetBSD
+#elif defined(__APPLE__)
+#  define OSDarwin
 #else
 #  error Unknown architecture - cannot build start-stop-daemon
 #endif
@@ -49,7 +51,8 @@
 #include <ps.h>
 #endif
 
-#if defined(OSOpenBSD) || defined(OSFreeBSD) || defined(OSNetBSD)
+#if defined(OSOpenBSD) || defined(OSFreeBSD) || defined(OSNetBSD) || defined(OSDarwin)
+#include <sys/time.h>
 #include <sys/param.h>
 #include <sys/proc.h>
 #include <sys/stat.h>
@@ -804,7 +807,7 @@
 #if defined(OSLinux) || defined(OShpux)
 	if (execname && !pid_is_exec(pid, &exec_stat))
 		return;
-#elif defined(OSHURD) || defined(OSFreeBSD) || defined(OSNetBSD)
+#elif defined(OSHURD) || defined(OSFreeBSD) || defined(OSNetBSD) || defined(OSDarwin)
 	/* Let's try this to see if it works */
 	if (execname && !pid_is_cmd(pid, execname))
 		return;
@@ -882,6 +882,7 @@
 }
 #endif /* OSHURD */
 
+#if defined(OSOpenBSD) || defined(OSFreeBSD) || defined(OSNetBSD)
 #ifdef HAVE_KVM_H
 static int
 pid_is_cmd(pid_t pid, const char *name)
@@ -974,6 +975,7 @@
 {
 	/* Nothing to do */
 }
+#endif
 #endif /* OSOpenBSD */
 
 #if defined(OShpux)
@@ -975,6 +954,80 @@
 	/* Nothing to do */
 }
 #endif /* OSOpenBSD */
+
+#if defined(OSDarwin)
+#include <sys/sysctl.h>
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
+#endif /* OSDarwin */
 
 #if defined(OShpux)
 static int
