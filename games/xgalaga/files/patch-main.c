--- main.c.orig	Mon May 11 15:52:59 1998
+++ main.c	Wed Jun 27 02:53:46 2007
@@ -7,6 +7,7 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #ifdef HAVE_SYS_TIME_H
 #include <sys/time.h>
 #endif
@@ -779,6 +780,7 @@
     if(gameOver) {
         while(W_EventsPending()) {
             W_NextEvent(&wev);
+	    if (wev.key >= 256) wev.key -= 256;
         
 	    if(gameOver)
 	      mouseControl = 1;
@@ -826,6 +828,7 @@
 
     while(W_EventsPending()) {
         W_NextEvent(&wev);
+	if (wev.key >= 256) wev.key -= 256;
 
         switch(wev.type) {
         case W_EV_KEY_OFF:
