--- logview/logrtns.c.org	Sun Jul 27 18:15:28 2003
+++ logview/logrtns.c	Sun Jul 27 18:16:30 2003
@@ -790,11 +790,11 @@
       if (IsLeapYear (curmark->year - lastyear + thisyear))
 	 curmark->time += 24 * 60 * 60;		/*  Add one day */
 
-#if defined(__NetBSD__) || defined(__FreeBSD__)
+/* #if defined(__NetBSD__) || defined(__FreeBSD__) */
       curmark->time += correction - tmptm->tm_gmtoff;
-#else
+/* #else
       curmark->time += correction - timezone;
-#endif
+#endif */
 
       memcpy (&curmark->fulldate, localtime (&curmark->time), sizeof (struct tm));
 
@@ -816,22 +816,22 @@
    if (IsLeapYear (thisyear))
       log->lstats.enddate += 24 * 60 * 60;	/*  Add one day */
 
-#if defined(__NetBSD__) || defined(__FreeBSD__)
+/* #if defined(__NetBSD__) || defined(__FreeBSD__) */
    log->lstats.enddate += correction - tmptm->tm_gmtoff;
-#else
+/* #else
    log->lstats.enddate += correction - timezone;
-#endif
+#endif */
 
    footm.tm_year = thisyear - lastyear;
    correction = mktime (&footm);
    if (IsLeapYear (thisyear - lastyear))
       log->lstats.startdate += 24 * 60 * 60;	/*  Add one day */
 
-#if defined(__NetBSD__) || defined(__FreeBSD__)
+/* #if defined(__NetBSD__) || defined(__FreeBSD__) */
    log->lstats.startdate += correction - tmptm->tm_gmtoff;
-#else
+/* #else
    log->lstats.startdate += correction - timezone;
-#endif
+#endif*/
    log->lstats.numlines = nl;
 
    return;
