--- src/common/proto-irc.c.orig	2005-09-28 00:18:53.000000000 -0700
+++ src/common/proto-irc.c	2005-09-28 00:18:57.000000000 -0700
@@ -761,8 +761,11 @@
 
 	if (len == 4)
 	{
+		guint32 t;
+
+		t = WORDL((guint8)type[0], (guint8)type[1], (guint8)type[2], (guint8)type[3]); 	
 		/* this should compile to a bunch of: CMP.L, JE ... nice & fast */
-		switch (*((guint32 *)type))
+		switch (t)
 		{
 		case WORDL('J','O','I','N'):
 			{
@@ -838,8 +841,11 @@
 
 	else if (len >= 5)
 	{
+		guint32 t;
+
+		t = WORDL((guint8)type[0], (guint8)type[1], (guint8)type[2], (guint8)type[3]); 	
 		/* this should compile to a bunch of: CMP.L, JE ... nice & fast */
-		switch (*((guint32 *)type))
+		switch (t)
 		{
 		case WORDL('I','N','V','I'):
 			if (ignore_check (word[1], IG_INVI))
@@ -1022,7 +1028,7 @@
 	}
 
 	/* see if the second word is a numeric */
-	if (isdigit (word[2][0]))
+	if (isdigit ((unsigned char) word[2][0]))
 	{
 		text = word_eol[4];
 		if (*text == ':')
