
$FreeBSD: ports/news/pan2/files/patch-pan::filters::filter-phrase.h,v 1.2 2001/11/13 11:16:30 sobomax Exp $

--- pan/filters/filter-phrase.h.orig	Thu Oct 25 18:49:53 2001
+++ pan/filters/filter-phrase.h	Tue Nov 13 12:33:06 2001
@@ -25,7 +25,7 @@
 #define __FILTER_PHRASE_H__
 
 #include <sys/types.h>
-#include <regex.h>
+#include <gnuregex.h>
 
 #include <pan/filters/filter.h>
 
