--- mozilla/MozillaPrivate.cpp.org	Tue Jan 11 16:39:00 2005
+++ mozilla/MozillaPrivate.cpp	Tue Jan 11 16:39:34 2005
@@ -111,8 +111,8 @@
 
 		// mark locale default paper size so that print dialog can use
 		// it as best guess when switching printers
-		if (height == (int) (long int) nl_langinfo (_NL_PAPER_HEIGHT) &&
-		    width == (int) (long int) nl_langinfo (_NL_PAPER_WIDTH))
+		if (height == (int) (long int) nl_langinfo (1) &&
+		    width == (int) (long int) nl_langinfo (1))
 		{
 			info->paper = i;
 		}
