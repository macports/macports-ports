--- src/common/url.c.orig	2005-09-28 00:19:37.000000000 -0700
+++ src/common/url.c	2005-09-28 00:19:43.000000000 -0700
@@ -19,6 +19,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <ctype.h>
 #include "xchat.h"
 #include "cfgfiles.h"
 #include "fe.h"
@@ -124,66 +125,61 @@
 int
 url_check_word (char *word, int len)
 {
-	char *at, *dot;
+#define D(x) (x), ((sizeof (x)) - 1)
+	static const struct {
+		const char *s;
+		int len;
+	}
+	prefix[] = {
+		{ D("irc.") },
+		{ D("ftp.") },
+		{ D("www.") },
+		{ D("irc://") },
+		{ D("ftp://") },
+		{ D("http://") },
+		{ D("https://") },
+		{ D("file://") },
+		{ D("rtsp://") },
+		{ D("gopher://") },
+	},
+	suffix[] = {
+		{ D(".org") },
+		{ D(".net") },
+		{ D(".com") },
+		{ D(".edu") },
+		{ D(".html") },
+		{ D(".info") },
+		{ D(".name") },
+	};
+#undef D
+	const char *at, *dot;
 	int i, dots;
-	char temp[4];
-	guint32 pre;
 
-	if ((word[0] == '@' || word[0] == '+' || word[0] == '^' || word[0] == '%' || word[0] == '*' ) && word[1] == '#')
+	if (len > 1 && word[1] == '#' && strchr("@+^%*#", word[0]))
 		return WORD_CHANNEL;
 
 	if ((word[0] == '#' || word[0] == '&') && word[1] != '#' && word[1] != 0)
 		return WORD_CHANNEL;
 
-	if (len > 4 && word[4] != '.')
+	for (i = 0; i < G_N_ELEMENTS(prefix); i++)
 	{
-		temp[0] = tolower (word[0]);
-		temp[1] = tolower (word[1]);
-		temp[2] = tolower (word[2]);
-		temp[3] = tolower (word[3]);
-
-		pre = *((guint32 *)temp);
-
-		if (CMPL (pre, 'i','r','c','.'))
-			return WORD_URL;
-		if (CMPL (pre, 'f','t','p','.'))
-			return WORD_URL;
-		if (CMPL (pre, 'w','w','w','.'))
-			return WORD_URL;
+		int l;
 
-		if (len > 7 && word[4] == '/' && word[5] == '/')
+		l = prefix[i].len;
+		if (len > l)
 		{
-			if (CMPL (pre, 'i','r','c',':'))	/* irc:// */
-				return WORD_URL;
-			if (CMPL (pre, 'f','t','p',':'))	/* ftp:// */
-				return WORD_URL;
-		}
+			int j;
 
-		/* check for ABCD://... */
-		if (len > 8 && word[4] == ':' && word[5] == '/' && word[6] == '/')
-		{
-			if (CMPL (pre, 'h','t','t','p'))		/* http:// */
-				return WORD_URL;
-			if (CMPL (pre, 'f','i','l','e'))		/* file:// */
-				return WORD_URL;
-			if (CMPL (pre, 'r','t','s','p'))		/* rtsp:// */
-				return WORD_URL;
-		}
-
-		/* check for https:// */
-		if (len > 9 && word[5] == ':' && word[6] == '/' && word[7] == '/')
-		{
-			if (CMPL (pre, 'h','t','t','p') && (word[4] == 's' || word[4] == 'S'))
+			/* This is pretty much strncasecmp(). */
+			for (j = 0; j < l; j++)
+			{
+				unsigned char c = word[j];
+				if (tolower(c) != prefix[i].s[j])
+					break;
+			}
+			if (j == l)
 				return WORD_URL;
 		}
-
-		/* check for gopher:// */
-		if (len > 10 && word[6] == ':' && word[7] == '/' && word[8] == '/')
-		{
-			if (CMPL (pre, 'g','o','p','h'))
-				if (CMPW (word + 4, 'e','r') || CMPW (word + 4, 'E','R'))
-					return WORD_URL;
-		}
 	}
 
 	at = strchr (word, '@');	  /* check for email addy */
@@ -205,7 +201,7 @@
 	{
 		if (word[i] == '.' && i > 1)
 			dots++;	/* allow 127.0.0.1:80 */
-		else if (!isdigit (word[i]) && word[i] != ':')
+		else if (!isdigit ((unsigned char) word[i]) && word[i] != ':')
 		{
 			dots = 0;
 			break;
@@ -216,35 +212,30 @@
 
 	if (len > 5)
 	{
-		/* create a lowercase version of the last 4 letters */
-		temp[0] = tolower (word[len - 4]);
-		temp[1] = tolower (word[len - 3]);
-		temp[2] = tolower (word[len - 2]);
-		temp[3] = tolower (word[len - 1]);
+		for (i = 0; i < G_N_ELEMENTS(suffix); i++)
+		{
+			int l;
 
-		pre = *((guint32 *)temp);
+			l = suffix[i].len;
+			if (len > l)
+			{
+				const unsigned char *p = &word[len - l];
+				int j;
 
-		if (word[len - 5] == '.')
-		{
-			if (CMPL (pre, 'h','t','m','l'))
-				return WORD_HOST;
-			if (CMPL (pre, 'i','n','f','o'))
-				return WORD_HOST;
-			if (CMPL (pre, 'n','a','m','e'))
-				return WORD_HOST;
+				/* This is pretty much strncasecmp(). */
+				for (j = 0; j < l; j++)
+				{
+					if (tolower(p[j]) != suffix[i].s[j])
+						break;
+				}
+				if (j == l)
+					return WORD_HOST;
+			}
 		}
 
-		if (CMPL (pre, '.','o','r','g'))
-			return WORD_HOST;
-		if (CMPL (pre, '.','n','e','t'))
-			return WORD_HOST;
-		if (CMPL (pre, '.','c','o','m'))
-			return WORD_HOST;
-		if (CMPL (pre, '.','e','d','u'))
-			return WORD_HOST;
-
 		if (word[len - 3] == '.' &&
-			 isalpha (word[len - 2]) && isalpha (word[len - 1]))
+			 isalpha ((unsigned char) word[len - 2]) &&
+				isalpha ((unsigned char) word[len - 1]))
 			return WORD_HOST;
 	}
 
