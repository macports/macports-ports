diff -urN ../ijb-zlib-11.orig/bind.c ./bind.c
--- ../ijb-zlib-11.orig/bind.c	Thu Aug  3 23:38:32 2000
+++ ./bind.c	Thu Jan  6 15:39:42 2005
@@ -37,7 +37,7 @@
 #endif
 
 #ifdef REGEX
-#include <gnu_regex.h>
+#include <gnuregex.h>
 #endif
 
 #include "jcc.h"	/* For atoip() */
@@ -45,6 +45,242 @@
 long  remote_ip_long;
 char *remote_ip_str;
 
+#ifdef HAVE_IPV6
+#ifdef HAVE_POLL
+/*
+ * Do we have the superiour poll() interface?
+ */
+#include <sys/poll.h>
+
+static struct pollfd	*b_pfd;
+static int		nr_fds;
+#else
+/*
+ * Argh, we've only got the select() interface.
+ */
+#include <sys/select.h>
+
+static fd_set		sfd;
+static int		max_fd;
+#endif
+
+static int add_fd(fd)
+	int fd;
+{
+#ifdef HAVE_POLL
+	struct pollfd *n;
+	int nr = nr_fds + 1;
+
+	n = realloc(b_pfd, nr * sizeof(*n));
+	if (!n)
+		return -3;
+
+	n[nr_fds].fd     = fd;
+	n[nr_fds].events = POLLIN;
+
+	b_pfd  = n;
+	nr_fds = nr;
+
+	return 0;
+#else
+	if (fd >= max_fd)
+		max_fd = fd + 1;
+	FD_SET(fd, &sfd);
+	return 0;
+#endif
+}
+
+/*
+ * Bind one port of an address family, specified by `ai'
+ */
+static int bind_one(ai)
+	struct addrinfo *ai;
+{
+	int fd, one = 1;
+
+	fd = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
+	if (fd == -1) {
+		/*
+		 * Is it an unsupported family or protocol?
+		 * Move along please.
+		 */
+		if (errno == EINVAL || errno == EPROTONOSUPPORT)
+			return -1;
+
+		/*
+		 * Ok, something else went wrong - fatal error.
+		 */
+		return -3;
+	}
+
+	setsockopt(fd, SOL_SOCKET, SO_REUSEADDR,
+		   (char *)&one, sizeof(one));
+
+	/*
+	 * Now bind the socket.  This may fail on Linux.
+	 */
+	if (bind(fd, ai->ai_addr, ai->ai_addrlen) < 0) {
+		close(fd);
+
+		if (errno == EADDRINUSE)
+			return -2;
+		else
+			return -1;
+	}
+
+	/*
+	 * and ensure that it is listening.
+	 */
+	while (listen(fd, 5) == -1) {
+		if (errno != EINTR) {
+			close(fd);
+			return -1;
+		}
+	}
+
+	return add_fd(fd);
+}
+
+/*
+ * BIND-PORT (portnum)
+ *  if success, return file descriptor
+ *  if failure, returns -2 if address is in use, otherwise -1
+ */
+int 	bind_port (hostnam, portnum)
+char	*hostnam;
+int	 portnum;
+{
+	struct addrinfo *ai, *aip, aihint;
+	int rc, nr = 0;
+	char serv[NI_MAXSERV];
+
+	if (snprintf(serv, NI_MAXSERV, "%d", portnum) >= NI_MAXSERV)
+		return -1;
+
+	memset(&aihint, 0, sizeof(aihint));
+
+	aihint.ai_flags = AI_PASSIVE;
+	aihint.ai_family = PF_UNSPEC;
+	aihint.ai_socktype = SOCK_STREAM;
+
+	rc = getaddrinfo(hostnam, serv, &aihint, &ai);
+	if (rc)
+		return -1;
+
+	/*
+	 * Go through each entry creating a socket and trying
+	 * to bind it.  Note that on Linux, if we bind to an
+	 * IPv6 address, we can't bind to it's corresponding
+	 * IPv4 address, so we bind IPv6 first, then IPv4.
+	 * 
+	 * We classify success as being able to establish at
+	 * least one listening socket.
+	 */
+	for (aip = ai; aip; aip = aip->ai_next) {
+		if (aip->ai_family == PF_INET6) {
+			rc = bind_one(aip);
+			if (rc == 0)
+				nr++;
+		}
+	}
+
+	for (aip = ai; aip; aip = aip->ai_next) {
+		if (aip->ai_family == PF_INET) {
+			rc = bind_one(aip);
+			if (rc == 0)
+				nr++;
+		}
+	}
+
+	freeaddrinfo(ai);
+
+	if (nr != 0)
+		rc = 0;
+
+	return rc;
+}
+
+/* 
+ * ACCEPT-CONNECTION
+ * the argument, fd, is the value returned from bind_port
+ *
+ * when a connection is accepted, it returns the file descriptor
+ * for the connected port
+ */
+int	accept_connection (_fd)
+int	_fd;
+{
+	struct sockaddr_storage sa;
+	int afd, alen = sizeof(sa);
+	char host[NI_MAXHOST];
+	int rc, fd;
+
+#ifdef HAVE_POLL
+	int i;
+
+	do {
+		rc = poll(b_pfd, nr_fds, -1);
+	} while (rc == 0 || (rc == -1 && errno == EINTR));
+
+	/*
+	 * I wish we could spawn the handler here.  Alas, without
+	 * rewriting more of ijb...
+	 */
+	for (i = 0; i < nr_fds; i++)
+		if (b_pfd[i].revents)
+			break;
+
+	/*
+	 * hmm, if we ran out of fds to check, someone lied to us.
+	 */
+	if (i >= nr_fds)
+		return -1;
+
+	fd = b_pfd[i].fd;
+#else
+	fd_set rfds;
+
+	rfds = sfd;
+	do {
+		rc = select(max_fd, &rfds, NULL, NULL, NULL);
+	} while (rc == 0 || (rc == -1 && errno == EINTR));
+
+	/*
+	 * Find the first fd.  Same comment as above.
+	 */
+	for (fd = 0; fd < max_fd; fd++)
+		if (FD_ISSET(fd, &rfds))
+			break;
+
+	/*
+	 * If we found no fds, someone lied to us.
+	 */
+	if (fd >= max_fd)
+		return -1;
+
+#endif
+	afd = accept(fd, (struct sockaddr *)&sa, &alen);
+	if (afd < 0)
+		return -1;
+
+	if (getnameinfo((struct sockaddr *)&sa, alen,
+			host, NI_MAXHOST,
+			NULL, 0, NI_NUMERICHOST))
+		strcpy(host, "unknown");
+
+	remote_ip_str = strdup(host);
+	remote_ip_long = 0;
+
+	return afd;
+}
+#else
+/*
+ * -------------------------------- IPv4 ----------------------------
+ */
+
+extern int atoip();
+
+
 /*
  * BIND-PORT (portnum)
  *  if success, return file descriptor
@@ -100,7 +336,6 @@
 	return fd;
 }
 
-
 /* 
  * ACCEPT-CONNECTION
  * the argument, fd, is the value returned from bind_port
@@ -128,3 +363,5 @@
 
 	return afd;
 }
+#endif
+
