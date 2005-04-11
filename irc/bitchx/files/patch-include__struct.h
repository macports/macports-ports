--- include/struct.h.orig	2005-04-03 07:27:25.000000000 -0400
+++ include/struct.h	2005-04-03 07:27:45.000000000 -0400
@@ -1064,7 +1064,6 @@
 	int	delete;
 }	TimerList;
 
-extern TimerList *PendingTimers;
 typedef struct nicktab_stru
 {
 	struct nicktab_stru *next;
