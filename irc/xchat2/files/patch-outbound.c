--- src/common/outbound.c.orig	2005-09-28 00:17:58.000000000 -0700
+++ src/common/outbound.c	2005-09-28 00:18:02.000000000 -0700
@@ -1498,7 +1498,7 @@
 					k = 0;
 				} else
 				{
-					if (isdigit (buf[i]) && k < (sizeof (numb) - 1))
+					if (isdigit ((unsigned char) buf[i]) && k < (sizeof (numb) - 1))
 					{
 						numb[k] = buf[i];
 						k++;
@@ -1899,7 +1899,7 @@
 	p = name;
 	while (*p)
 	{
-		hl->buf[len] = toupper (*p);
+		hl->buf[len] = toupper ((unsigned char) *p);
 		len++;
 		p++;
 	}
@@ -2136,7 +2136,7 @@
 
 		user = find_name (sess, nick);
 
-		if (isdigit (reason[0]) && reason[1] == 0)
+		if (isdigit ((unsigned char) reason[0]) && reason[1] == 0)
 		{
 			ban (sess, tbuf, nick, reason, (user && user->op));
 			reason[0] = 0;
@@ -3287,9 +3287,9 @@
 	{
 		if (src[0] == '%' || src[0] == '&')
 		{
-			if (isdigit (src[1]))
+			if (isdigit ((unsigned char) src[1]))
 			{
-				if (isdigit (src[2]) && isdigit (src[3]))
+				if (isdigit ((unsigned char) src[2]) && isdigit ((unsigned char) src[3]))
 				{
 					buf[0] = src[1];
 					buf[1] = src[2];
@@ -3442,8 +3442,8 @@
 				occur++;
 				if (	do_ascii &&
 						j + 3 < len &&
-						(isdigit (cmd[j + 1]) && isdigit (cmd[j + 2]) &&
-						isdigit (cmd[j + 3])))
+						(isdigit ((unsigned char) cmd[j + 1]) && isdigit ((unsigned char) cmd[j + 2]) &&
+						isdigit ((unsigned char) cmd[j + 3])))
 				{
 					tbuf[0] = cmd[j + 1];
 					tbuf[1] = cmd[j + 2];
