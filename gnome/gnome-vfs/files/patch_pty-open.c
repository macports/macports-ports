--- modules/pty-open.c.org	Fri Sep 17 17:43:28 2004
+++ modules/pty-open.c	Fri Sep 17 17:49:03 2004
@@ -554,51 +554,6 @@
 static char *
 _gnome_vfs_pty_ptsname(int master)
 {
-#if defined(HAVE_PTSNAME_R)
-	gsize len = 1024;
-	char *buf = NULL;
-	int i;
-	do {
-		buf = g_malloc0(len);
-		i = ptsname_r(master, buf, len - 1);
-		switch (i) {
-		case 0:
-			/* Return the allocated buffer with the name in it. */
-#ifdef GNOME_VFS_DEBUG
-			if (_gnome_vfs_debug_on(GNOME_VFS_DEBUG_PTY)) {
-				fprintf(stderr, "PTY slave is `%s'.\n", buf);
-			}
-#endif
-			return buf;
-			break;
-		default:
-			g_free(buf);
-			buf = NULL;
-			break;
-		}
-		len *= 2;
-	} while ((i != 0) && (errno == ERANGE));
-#elif defined(HAVE_PTSNAME)
-	char *p;
-	if ((p = ptsname(master)) != NULL) {
-#ifdef GNOME_VFS_DEBUG
-		if (_gnome_vfs_debug_on(GNOME_VFS_DEBUG_PTY)) {
-			fprintf(stderr, "PTY slave is `%s'.\n", p);
-		}
-#endif
-		return g_strdup(p);
-	}
-#elif defined(TIOCGPTN)
-	int pty = 0;
-	if (ioctl(master, TIOCGPTN, &pty) == 0) {
-#ifdef GNOME_VFS_DEBUG
-		if (_gnome_vfs_debug_on(GNOME_VFS_DEBUG_PTY)) {
-			fprintf(stderr, "PTY slave is `/dev/pts/%d'.\n", pty);
-		}
-#endif
-		return g_strdup_printf("/dev/pts/%d", pty);
-	}
-#endif
 	return NULL;
 }
 
@@ -606,18 +561,13 @@
 _gnome_vfs_pty_getpt(void)
 {
 	int fd, flags;
-#ifdef HAVE_GETPT
-	/* Call the system's function for allocating a pty. */
-	fd = getpt();
-#elif defined(HAVE_POSIX_OPENPT)
-	fd = posix_openpt(O_RDWR | O_NOCTTY);
-#else
-	/* Try to allocate a pty by accessing the pty master multiplex. */
-	fd = open("/dev/ptmx", O_RDWR | O_NOCTTY);
-	if ((fd == -1) && (errno == ENOENT)) {
-		fd = open("/dev/ptc", O_RDWR | O_NOCTTY); /* AIX */
-	}
-#endif
+
+        /* Try to allocate a pty by accessing the pty master multiplex. */
+        fd = open("/dev/ptmx", O_RDWR | O_NOCTTY);
+        if ((fd == -1) && (errno == ENOENT)) {
+                fd = open("/dev/ptc", O_RDWR | O_NOCTTY); /* AIX */
+        }
+
 	/* Set it to blocking. */
 	flags = fcntl(fd, F_GETFL);
 	flags &= ~(O_NONBLOCK);
@@ -628,24 +578,13 @@
 static int
 _gnome_vfs_pty_grantpt(int master)
 {
-#ifdef HAVE_GRANTPT
-	return grantpt(master);
-#else
 	return 0;
-#endif
 }
 
 static int
 _gnome_vfs_pty_unlockpt(int fd)
 {
-#ifdef HAVE_UNLOCKPT
-	return unlockpt(fd);
-#elif defined(TIOCSPTLCK)
-	int zero = 0;
-	return ioctl(fd, TIOCSPTLCK, &zero);
-#else
 	return -1;
-#endif
 }
 
 static int
