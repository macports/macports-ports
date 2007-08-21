--- liferea-1.2.22-old/src/itemview.c	2007-03-14 21:57:34.000000000 +0100
+++ liferea-1.2.22-new/src/itemview.c	2007-08-20 04:44:43.000000000 +0200
@@ -245,15 +245,12 @@
 /* date format handling (not sure if this is the right place) */
 
 gchar * itemview_format_date(time_t date) {
-	gchar		*timestr, *tmp;
+	gchar		*timestr;
 
 	if(itemView_priv.userDefinedDateFmt)
-		tmp = common_format_date(date, itemView_priv.userDefinedDateFmt);
+		timestr = common_format_date(date, itemView_priv.userDefinedDateFmt);
 	else
-		tmp = common_format_nice_date(date);
-	
-	timestr = g_locale_to_utf8(tmp, -1, NULL, NULL, NULL);
-	g_free(tmp);
+		timestr = common_format_nice_date(date);
 	
 	return timestr;
 }
