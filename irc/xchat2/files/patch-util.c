--- src/common/util.c.orig	2005-09-28 00:15:57.000000000 -0700
+++ src/common/util.c	2005-09-28 00:16:01.000000000 -0700
@@ -435,8 +435,8 @@
 
 	while (len > 0)
 	{
-		if ((col && isdigit (*text) && nc < 2) ||
-			 (col && *text == ',' && isdigit (*(text+1)) && nc < 3))
+		if ((col && isdigit ((unsigned char) *text) && nc < 2) ||
+			 (col && *text == ',' && isdigit ((unsigned char) *(text+1)) && nc < 3))
 		{
 			nc++;
 			if (*text == ',')
@@ -1084,7 +1084,7 @@
 	char *p;
 	domain_t *dom;
 
-	if (!hostname || !*hostname || isdigit (hostname[strlen (hostname) - 1]))
+	if (!hostname || !*hostname || isdigit ((unsigned char) hostname[strlen (hostname) - 1]))
 		return _("Unknown");
 	if ((p = strrchr (hostname, '.')))
 		p++;
@@ -1156,7 +1156,7 @@
 		if (*src != quote) *buf++ = '\\';
 	    }
 	    *buf++ = *src;
-	} else if (isspace(*src)) {
+	} else if (isspace((unsigned char) *src)) {
 	    if (*argv[argc]) {
 		buf++, argc++;
 		if (argc == argvAlloced) {
