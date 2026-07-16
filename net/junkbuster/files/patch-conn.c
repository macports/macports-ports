diff -urN ../ijb-zlib-11.orig/conn.c ./conn.c
--- ../ijb-zlib-11.orig/conn.c	Thu Aug  3 23:38:35 2000
+++ ./conn.c	Thu Jan  6 15:39:42 2005
@@ -38,7 +38,11 @@
 #endif
 
 #ifdef REGEX
-#include "gnu_regex.h"
+#include <gnuregex.h>
+#endif
+
+#ifdef HAVE_POLL
+#include <sys/poll.h>
 #endif
 
 #include "jcc.h"
@@ -82,14 +86,127 @@
 	return(inaddr.sin_addr.s_addr);
 }
 
+#ifdef HAVE_IPV6
+int connect_to(char *host, int portnum, struct client_state *csp)
+{
+	struct addrinfo *ai, *aip, aihint;
+	int fd = -1, rc;
+	char serv[NI_MAXSERV];
+
+	if (snprintf(serv, NI_MAXSERV, "%d", portnum) >= NI_MAXSERV) {
+		errno = EOVERFLOW;
+		return -1;
+	}
+
+	memset(&aihint, 0, sizeof(aihint));
+
+	aihint.ai_family = PF_UNSPEC;
+	aihint.ai_socktype = SOCK_STREAM;
+
+	rc = getaddrinfo(host, serv, &aihint, &ai);
+	if (rc)
+		return -1;
+
+	/*
+	 * Go through each entry trying to connect to the host.
+	 */
+	for (aip = ai; aip; aip = aip->ai_next) {
+		int flags;
+
+		fd = socket(aip->ai_family, aip->ai_socktype, aip->ai_protocol);
+		if (fd == -1)
+			continue;
+
+#ifdef TCP_NODELAY	/* turn off TCP coalescence */
+		{
+			int mi = 1;
+			setsockopt(fd, IPPROTO_TCP, TCP_NODELAY, (char *)&mi, sizeof(mi));
+		}
+#endif
+#if !defined(_WIN32) && !defined(__BEOS__)
+		flags = fcntl(fd, F_GETFL, 0);
+		if (flags != -1)
+			fcntl(fd, F_SETFL, flags | O_NDELAY);
+#endif
+		do {
+			rc = connect(fd, aip->ai_addr, aip->ai_addrlen);
+		} while (rc == -1 && errno == EINTR);
+
+		if (rc == -1 && errno != EINPROGRESS) {
+			close(fd);
+			fd = -1;
+			continue;
+		}
+
+		/*
+		 * Ok, the connection is in progress.
+		 */
+#if !defined(_WIN32) && !defined(__BEOS__)
+		if (flags != -1)
+			fcntl(fd, F_SETFL, flags);
+#endif
+		{
+#ifdef HAVE_POLL
+			struct pollfd pfd;
+
+			pfd.fd = fd;
+			pfd.events = POLLOUT | POLLERR | POLLHUP;
+
+			if (poll(&pfd, 1, 30000) <= 0) {
+				close(fd);
+				fd = -1;
+				continue;
+			}
+
+			if (pfd.revents & (POLLERR|POLLHUP)) {
+				close(fd);
+				fd = -1;
+				continue;
+			}
+#else
+			fd_set rfds, wfds;
+			struct timeval tv[1];
+
+			FD_ZERO(&rfds);
+			FD_ZERO(&wfds);
+			FD_SET(fd, &rfds);
+			FD_SET(fd, &wfds);
+
+			tv->tv_sec  = 30;
+			tv->tv_usec = 0;
+
+			if (select(fd + 1, &rfds, &wfds, NULL, tv) <= 0) {
+				(void) close(fd);
+				fd = -1;
+				continue;
+			}
+
+			if (FD_ISSET(fd, &rfds) && FD_ISSET(fd, &wfds)) {
+				int r = 0, l = sizeof(r);
+
+				if (getsockopt(fd, SOL_SOCKET, SO_ERROR, &r, &l)
+				    || r) {
+					(void) close(fd);
+					fd = -1;
+					continue;
+				}
+			}
+#endif
+		}
+		break;
+	}
+
+	freeaddrinfo(ai);
 
+	return fd;
+}
+
+#else
 int
 connect_to(char *host, int portnum, struct client_state *csp)
 {
 	struct sockaddr_in inaddr;
 	int	fd, addr;
-	fd_set wfds;
-	struct timeval tv[1];
 	int	flags;
 	struct access_control_addr src[1], dst[1];
 
@@ -122,23 +239,19 @@
 	}
 
 #ifdef TCP_NODELAY
-{	/* turn off TCP coalescence */
-	int	mi = 1;
-	setsockopt (fd, IPPROTO_TCP, TCP_NODELAY, (char * ) &mi, sizeof (int));
-}
+	{	/* turn off TCP coalescence */
+		int	mi = 1;
+		setsockopt (fd, IPPROTO_TCP, TCP_NODELAY, (char * ) &mi, sizeof (int));
+	}
 #endif
-
-#ifndef _WIN32
-#ifndef __BEOS__
+#if !defined(_WIN32) && !defined(__BEOS__)
 	if ((flags = fcntl(fd, F_GETFL, 0)) != -1) {
 		flags |= O_NDELAY;
 		fcntl(fd, F_SETFL, flags);
 	}
 #endif
-#endif
 
 	while (connect(fd, (struct sockaddr *) & inaddr, sizeof inaddr) == -1) {
-
 #ifdef _WIN32
 		if (errno == WSAEINPROGRESS)
 #else
@@ -154,25 +267,59 @@
 		}
 	}
 
-#ifndef _WIN32
-#ifndef __BEOS__
+#if !defined(_WIN32) && !defined(__BEOS__)
 	if (flags != -1) {
 		flags &= ~O_NDELAY;
 		fcntl(fd, F_SETFL, flags);
 	}
 #endif
-#endif
 
-	/* wait for connection to complete */
-	FD_ZERO(&wfds);
-	FD_SET(fd, &wfds);
+	{
+#ifdef HAVE_POLL
+		struct pollfd pfd;
+
+		pfd.fd = fd;
+		pfd.events = POLLOUT | POLLERR | POLLHUP;
+
+		if (poll(&pfd, 1, 30000) <= 0) {
+			close(fd);
+			return -1;
+		}
 
-	tv->tv_sec  = 30;
-	tv->tv_usec = 0;
+		if (pfd.revents & (POLLERR|POLLHUP)) {
+			close(fd);
+			return -1;
+		}
+#else
+		fd_set rfds, wfds;
+		struct timeval tv[1];
 
-	if (select(fd + 1, NULL, &wfds, NULL, tv) <= 0) {
-		(void) close(fd);
-		return(-1);
+		/* wait for connection to complete */
+		FD_ZERO(&rfds);
+		FD_ZERO(&wfds);
+		FD_SET(fd, &rfds);
+		FD_SET(fd, &wfds);
+
+		tv->tv_sec  = 30;
+		tv->tv_usec = 0;
+
+		if (select(fd + 1, &rfds, &wfds, NULL, tv) <= 0) {
+			(void) close(fd);
+			return(-1);
+		}
+
+		if (FD_ISSET(fd, &rfds) && FD_ISSET(fd, &wfds)) {
+			int r = 0, l = sizeof(r);
+
+			if (getsockopt(fd, SOL_SOCKET, SO_ERROR, &r, &l)
+			    || r) {
+				(void) close(fd);
+				fd = -1;
+			}
+		}
+#endif
 	}
+
 	return(fd);
 }
+#endif
