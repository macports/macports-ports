--- junk.c.orig	2009-03-20 22:50:41.000000000 -0700
+++ junk.c	2009-03-20 22:50:53.000000000 -0700
@@ -1033,7 +1033,7 @@
 	float	a = 1, b = 1, r;
 
 	if (verbose)
-		fprintf(stderr, "Examining message %d\n", m - &message[0] + 1);
+		fprintf(stderr, "Examining message %d\n", (int)(m - &message[0] + 1));
 	for (i = 0; i < BEST; i++) {
 		best[i].dist = 0;
 		best[i].prob = -1;
@@ -1061,7 +1061,7 @@
 	r = a+b > 0 ? a / (a+b) : 0;
 	if (verbose)
 		fprintf(stderr, "Junk probability of message %d: %g\n",
-				m - &message[0] + 1, r);
+				(int)(m - &message[0] + 1), r);
 	if (r > THR)
 		m->m_flag |= MJUNK;
 	else
