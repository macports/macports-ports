--- support/time.c.org	Fri Feb 13 15:16:17 2004
+++ support/time.c	Fri Feb 13 15:23:08 2004
@@ -102,15 +102,21 @@
 #if !defined(__palmos__)
 	static int initialized = 0;
 	static int isdst = 0;
+	static int tz = 0;
 	if(!initialized)
 	{
 		/* Call "localtime", which will initialise "timezone" for us */
 		time_t temp = time(0);
 		struct tm *tms = localtime(&temp);
 		isdst = tms->tm_isdst;
+		tz =tms->tm_gmtoff;
 		initialized = 1;
 	}
+	#ifdef __APPLE__
+	return (ILInt32)(-tz - (isdst ? 3600 : 0));
+	#else
 	return (ILInt32)(timezone - (isdst ? 3600 : 0));
+	#endif
 #else
 	/* TODO */
 	return 0;
