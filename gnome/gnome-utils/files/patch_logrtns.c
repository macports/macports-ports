--- logview/logrtns.c.org	2005-03-24 20:42:30.000000000 +0100
+++ logview/logrtns.c	2005-03-24 20:47:06.000000000 +0100
@@ -34,6 +34,7 @@
 #include "logview.h"
 #include "logrtns.h"
 #include <libgnomevfs/gnome-vfs-mime-utils.h>
+#include <stdlib.h>
 
 /*
  * -------------------
@@ -645,7 +646,7 @@
 	   if (IsLeapYear (curmark->year - lastyear + thisyear))
 		   curmark->time += 24 * 60 * 60;		/*  Add one day */
 	   
-#if defined(__NetBSD__) || defined(__FreeBSD__)
+#if defined(__NetBSD__) || defined(__FreeBSD__) || defined(__APPLE__)
 	   curmark->time += correction - tmptm->tm_gmtoff;
 #else
 	   curmark->time += correction - timezone;
@@ -669,7 +670,7 @@
    if (IsLeapYear (thisyear))
 	   log->lstats.enddate += 24 * 60 * 60;	/*  Add one day */
    
-#if defined(__NetBSD__) || defined(__FreeBSD__)
+#if defined(__NetBSD__) || defined(__FreeBSD__) || defined(__APPLE__)
    log->lstats.enddate += correction - tmptm->tm_gmtoff;
 #else
    log->lstats.enddate += correction - timezone;
@@ -680,7 +681,7 @@
    if (IsLeapYear (thisyear - lastyear))
 	   log->lstats.startdate += 24 * 60 * 60;	/*  Add one day */
 
-#if defined(__NetBSD__) || defined(__FreeBSD__)
+#if defined(__NetBSD__) || defined(__FreeBSD__) || defined(__APPLE__)
    log->lstats.startdate += correction - tmptm->tm_gmtoff;
 #else
    log->lstats.startdate += correction - timezone;
