--- src/NCString.cpp	Sun May 20 19:04:58 2001
+++ ../../NCString.cpp	Fri Nov  5 13:09:19 2004
@@ -1055,7 +1055,7 @@
 uint NCString::toULong(const char *str, bool *ok)
 {
 	int n;
-	ulong tmp = 0;
+	u_long tmp = 0;
 	if(str)
 	{
 		n = sscanf(str, "%lu", &tmp);
