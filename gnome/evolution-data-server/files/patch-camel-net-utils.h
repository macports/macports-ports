--- camel/camel-net-utils.h.org	2005-03-13 19:12:06.000000000 +0100
+++ camel/camel-net-utils.h	2005-03-13 19:12:47.000000000 +0100
@@ -34,55 +34,6 @@
 
 struct _CamelException;
 
-#ifdef NEED_ADDRINFO
-/* Some of this is copied from GNU's netdb.h
-
-  Copyright (C) 1996-2002, 2003, 2004 Free Software Foundation, Inc.
-  This file is part of the GNU C Library.
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Lesser General Public
-   License as published by the Free Software Foundation; either
-   version 2.1 of the License, or (at your option) any later version.
-*/
-struct addrinfo {
-	int ai_flags;
-	int ai_family;
-	int ai_socktype;
-	int ai_protocol;
-	size_t ai_addrlen;
-	struct sockaddr *ai_addr;
-	char *ai_canonname;
-	struct addrinfo *ai_next;
-};
-
-#define AI_CANONNAME	0x0002	/* Request for canonical name.  */
-#define AI_NUMERICHOST	0x0004	/* Don't use name resolution.  */
-
-/* Error values for `getaddrinfo' function.  */
-#define EAI_BADFLAGS	  -1	/* Invalid value for `ai_flags' field.  */
-#define EAI_NONAME	  -2	/* NAME or SERVICE is unknown.  */
-#define EAI_AGAIN	  -3	/* Temporary failure in name resolution.  */
-#define EAI_FAIL	  -4	/* Non-recoverable failure in name res.  */
-#define EAI_NODATA	  -5	/* No address associated with NAME.  */
-#define EAI_FAMILY	  -6	/* `ai_family' not supported.  */
-#define EAI_SOCKTYPE	  -7	/* `ai_socktype' not supported.  */
-#define EAI_SERVICE	  -8	/* SERVICE not supported for `ai_socktype'.  */
-#define EAI_ADDRFAMILY	  -9	/* Address family for NAME not supported.  */
-#define EAI_MEMORY	  -10	/* Memory allocation failure.  */
-#define EAI_SYSTEM	  -11	/* System error returned in `errno'.  */
-#define EAI_OVERFLOW	  -12	/* Argument buffer overflow.  */
-
-#define NI_MAXHOST      1025
-#define NI_MAXSERV      32
-
-#define NI_NUMERICHOST	1	/* Don't try to look up hostname.  */
-#define NI_NUMERICSERV	2	/* Don't convert port number to name.  */
-#define NI_NOFQDN	4	/* Only return nodename portion.  */
-#define NI_NAMEREQD	8	/* Don't return numeric addresses.  */
-#define NI_DGRAM	16	/* Look up UDP service rather than TCP.  */
-#endif
-
 struct addrinfo *camel_getaddrinfo(const char *name, const char *service,
 				   const struct addrinfo *hints, struct _CamelException *ex);
 void camel_freeaddrinfo(struct addrinfo *host);
