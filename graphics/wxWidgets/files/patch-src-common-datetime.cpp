--- src/common/datetime.cpp	Thu Nov 11 12:11:57 2004
+++ datetime.cpp	Thu Nov 11 12:11:50 2004
@@ -1168,16 +1168,11 @@
         // less than timezone - try to make it work for this case
         if ( tm2.tm_year == 70 && tm2.tm_mon == 0 && tm2.tm_mday == 1 )
         {
-            // add timezone to make sure that date is in range
-            tm2.tm_sec -= GetTimeZone();
-
-            timet = mktime(&tm2);
-            if ( timet != (time_t)-1 )
-            {
-                timet += GetTimeZone();
-
-                return Set(timet);
-            }
+            return Set((time_t)(
+                       GetTimeZone() +
+                       tm2.tm_hour * MIN_PER_HOUR * SEC_PER_MIN +
+                       tm2.tm_min * SEC_PER_MIN +
+                       tm2.tm_sec));
         }
 
         wxFAIL_MSG( _T("mktime() failed") );
@@ -1262,7 +1257,10 @@
         (void)Set(tm);
 
         // and finally adjust milliseconds
-        return SetMillisecond(millisec);
+        if (IsValid())
+            SetMillisecond(millisec);
+
+        return *this;
     }
     else
     {
