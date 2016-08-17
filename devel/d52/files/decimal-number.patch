--- common.c.sav	2007-10-19 12:45:37.000000000 -0400
+++ common.c	2007-10-19 12:47:03.000000000 -0400
@@ -473,9 +473,43 @@
 	*loc = i | c;
 }
 
+
+// Get decimal number from line in control file
+
+char *get_decimal(char *text, int *val)
+{
+	int	result;
+	char	c;
+
+	result = 0;
+	c = toupper(*text);
+
+	while (c)
+	{
+		if (c == ';')			// beginning of comment, ignore all else
+			break;
+
+		if (isdigit(c))
+		{
+			c -= '0';
+			result *= 10;
+			result += ((int) c & 0xf);
+			text++;
+		}
+		else
+			break;
+
+		c = toupper(*text);	// get next digit
+	}
+
+	*val = result;				// pass number back to caller
+	return(text);				// and return updated text pointer
+}
+
 //
 // Get hexadecimal number from line in control file.
 // Return updated character pointer.
+// If number preceeded by '#', then evaluate as a decimal number
 //
 
 char *get_adrs(char *text, int *val)
@@ -514,6 +548,11 @@
 			start++;
 			text++;
 		}
+		else if (c == '#')
+		{
+			text++;
+			return get_decimal(text, val);
+		}
 		else						// done if not hexadecimal character
 			break;
 
